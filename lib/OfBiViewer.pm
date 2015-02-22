package OfBiViewer;
use v5.12;
use strict;
use utf8;

use Dancer2;
use Dancer2::Plugin::Ajax;
use Data::Dumper;
use DBI;

our $VERSION = '0.1';

set serializer => 'JSON';

hook before_template_render => sub {
    my $tokens = shift;
    $tokens->{static_prefix} = config->{static_prefix} || request->uri_base();
};

get '/' => sub {
    template 'index';
};

# ajax is post, right?
any['get', 'post'] => '/api/bookselector' => sub {
    my %data = ();
    my %found_chapters = ();

    my $dbh = DBI->connect('dbi:'.config->{dbi_url},config->{dbi_user},config->{dbi_pw})
        or die "Connection Error: $DBI::errstr\n";
    my $sql =<<END;
SELECT
book.osis_name,
book.name,
book.chapters,
book.part,
chapter.number,
chapter.verses,
verse.version,
verse.from_number,
verse.to_number,
verse.status,
verse.text
FROM
bibelwikiofbi_book as book
LEFT OUTER JOIN bibelwikiofbi_chapter as chapter on book.id = chapter.book_id
LEFT OUTER JOIN bibelwikiofbi_verse as verse on chapter.id = verse.chapter_id
INNER JOIN bibelwikirevision as revision on verse.rev_id = revision.rev_id
INNER JOIN bibelwikipage as page on revision.rev_id = page.page_latest;
END
    my @result = @{ $dbh->selectall_arrayref($sql, { Slice => {} }) };

    for my $entry (@result) {
        if(not $entry->{"verse.version"}) {
            # No verses in this chapter yet.
            $data{overview}->{chapter_count}++;
        }
        else {
            # There actually are verses in this chapter.
            my $verse_count = $data{overview}->{"level".$entry->{"verse.status"}."_verses"} += $entry->{"verse.to_number"} - $entry->{"verse.from_number"} + 1;
            $data{overview}->{"level".$entry->{"verse.status"}."_verses"} += $verse_count;

            my %book = %{ $data{books}->{$entry->{"book.osis_name"}} };

            if (not $book{chapters}->{$entry->{"chapter.number"}}) {
                $data{overview}->{chapter_count}++;
                $data{overview}->{chapter_exists_count}++;
            }

            $book{osis_id} = $entry->{"book.osis_name"};
            $book{name} = $entry->{"book.name"};
            $book{chapter_count} = $entry->{"book.chapters"};
            $book{part} = $entry->{"book.part"};
            $book{$entry->{"verse.version"}}->{"level".$entry->{"verse.status"}."_verses"} += $verse_count;
            $book{$entry->{"verse.version"}}->{"level".$entry->{"verse.status"}."_chapters"}++ if (not $book{chapters}->{$entry->{"chapter.number"}});
            my %chapter = %{ $book{chapters}->{$entry->{"chapter.number"}} };
            $chapter{verse_count} = $entry->{"chapter.verses"};
            $chapter{$entry->{"verse.version"}}->{"level".$entry->{"verse.status"}."_verses"} += $verse_count;
            push (@{ $chapter{verses} }, [
                from_number => $entry->{"verse.from_number"},
                to_number =>   $entry->{"verse.to_number"},
                status =>      $entry->{"verse.status"},
                text =>        $entry->{"verse.text"},
            ]);
        }
    }
    return \%data;
};

=pod
    overview: {
        ls: {
            chapter_count: 1230
            chapter_exists_count: 120
            parse_failure_count: 12
            parse_ok_count: 108
            level1_verses: 123
            level2_verses: 1
            level3_verses: 2
            level4_verses: 23
        }
        ...
    }
    books: {
        1_Könige: {
            osis_id: 1Kgs
            name: 1_Könige
            chapter_count: 12
            part: ot
            ls: {
                chapter_exists_count: 6
                verse_exists_count: 123
                parse_failure_count: 2
                parse_ok_count: 3
                level1_chapters: 1
                level2_chapters: 0
                level3_chapters: 2
                level4_chapters: 3
                level1_verses: 123
                level2_verses: 1
                level3_verses: 2
                level4_verses: 23

            }
            ...
            chapters: {
                1: {
                    verses: 4,
                    ls: {
                        level1_verse_count: 123
                        level2_verse_count: 1
                        level3_verse_count: 2
                        level4_verse_count: 23
                    }
                    verses: [
                        {
                            from_number: 1
                            to_number: 1
                            status: 2
                            text: "Asdf"
                        }
                    ]
                }
            }
        }
        ...
    }
=cut

true;

