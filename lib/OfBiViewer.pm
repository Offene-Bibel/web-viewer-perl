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

{
package BookList;
use Moo;
use Dancer2;
use File::Spec;
use YAML::Any 'LoadFile';
use String::Util 'hascontent';

=pod
"index": {
    "1_Könige": {
        "1": {
            "ls": {
                "book": "1_Könige"
                "chapter": 1
                "version": "ls"
                "parse_status": 0
                "verse_count": 18 # should be static
                # "level0_count": 14 # Not translated, better leave that out and calculate it.
                "level1_count": 1 # in arbeit
                "level2_count": 1 # rohfassung
                "level3_count": 1 # fast fertig
                "level4_count": 1 # fertig
            }
            "lf": {...}
            "sf": {...}
        }
        "2": {...}
        ...
    }
    "2_Könige": {...}
    ...
}
/api/index => {
    "ls": {
        chapter_count: 1230
        chapter_exists_count: 120
        verse_exists_count: 12354
        parse_failure_count: 12
        parse_ok_count: 108
        level1_chapter_count: 1
        level2_chapter_count: 0
        level3_chapter_count: 2
        level4_chapter_count: 3
        level1_verse_count: 123
        level2_verse_count: 1
        level3_verse_count: 2
        level4_verse_count: 23
    }
    ...
}
/api/index/1_Könige => {
    "ls": {
        book: "1_Könige"
        chapter_count: 12
        chapter_exists_count: 5
        verse_exists_count: 123
        parse_failure_count: 2
        parse_ok_count: 3
        level1_chapter_count: 1
        level2_chapter_count: 0
        level3_chapter_count: 2
        level4_chapter_count: 3
        level1_verse_count: 123
        level2_verse_count: 1
        level3_verse_count: 2
        level4_verse_count: 23
    }
    ...
}
/api/index/1_Könige/1 => {
    "ls": {
        book: "1_Könige"
        chapter: 1
        level: 2
        verse_exists_count: 12
        parse_status: 1
        level1_verse_count: 1
        level2_verse_count: 1
        level3_verse_count: 2
        level4_verse_count: 23
    }
}
/api/bookselector => {
    overview: {
        ls: {
            chapter_count: 1230
            chapter_exists_count: 120
            verse_exists_count: 12354
            parse_failure_count: 12
            parse_ok_count: 108
            level1_verse_count: 123
            level2_verse_count: 1
            level3_verse_count: 2
            level4_verse_count: 23
        }
        ...
    }
    books: {
        1_Könige: {
            name: "1_Könige"
            chapter_count: 12
            versions: {
                ls: {
                    chapter_exists_count: 5
                    verse_exists_count: 123
                    parse_failure_count: 2
                    parse_ok_count: 3
                    level1_chapter_count: 1
                    level2_chapter_count: 0
                    level3_chapter_count: 2
                    level4_chapter_count: 3
                    level1_verse_count: 123
                    level2_verse_count: 1
                    level3_verse_count: 2
                    level4_verse_count: 23
                }
                ...
            }
        }
        ...
    }
}
=cut
has index => (
    is => 'ro',
);

sub BUILD {
    my $self = shift;
    my $args = shift;

    $self->constructIndex($args->{bookIndexFile});
}

sub constructIndex {
    my ($self, $fileName) = @_;
    $self->{index} = LoadFile($fileName);

    my @indexFilenames = @{config->{indexes}};
    for my $indexFilename (@indexFilenames) {
        my ($volume, $directories, $file) = File::Spec->splitpath( $indexFilename );
        open my $indexFile, "<:encoding(utf8)", $indexFilename or die "Index file not found: $indexFilename: $!";
        while (my $line = <$indexFile>) {
            next if $line =~ /^#/ or not hascontent $line;
            if ($line =~ /^(\w+) (\d+) (sf|lf|ls) (\d) (\w+)$/) {
                my $book = $1;
                my $chapter = $2;
                my $version = $3;
                my $status = $4;
                my $filename = File::Spec->catpath($volume, $directories, $5);

                my $bookEntry = $self->getBook($book);
                if(not defined $bookEntry) {
                    debug "Skipping $book, no valid book name.";
                    next;
                }
                if (defined $bookEntry->{$chapter}{$version}) {
                    debug "Skipping $version $book $chapter, found more than once.";
                    next;
                }
                if (not (-f -r -s $filename)) {
                    debug "Skipping $filename, check permissions and stuff.";
                    next;
                }

                $bookEntry->{chapters}{$chapter}{$version}{book} = $book;
                $bookEntry->{chapters}{$chapter}{$version}{chapter} = $chapter;
                $bookEntry->{chapters}{$chapter}{$version}{version} = $version;
                $bookEntry->{chapters}{$chapter}{$version}{status} = $status;
                $bookEntry->{chapters}{$chapter}{$version}{filename} = $filename;
            }
            else {
                die "Line $. in file $indexFilename is not valid. Aborting.";
            }
        }
        close $indexFile;
    }
}

sub getBook {
    my $self = shift;
    my $bookName = shift;
    foreach my $book (@{$self->{index}}) {
        if($bookName eq $book->{name}) {
            return $book;
        }
    }
    return undef;
}

sub books {
    my $self = shift;
    [map { $_->{name} } @{$self->{index}}];
}
}

my $bookList = BookList->new(bookIndexFile => config->{appdir}.'resources/bibleBooks.yml');

hook before_template_render => sub {
    my $tokens = shift;
    $tokens->{static_prefix} = config->{static_prefix} || request->uri_base();
};

ajax 'api/bookselector' => sub {
    books: {
        1_Könige: {
            name: 1_Könige
            chapter_count: 12
            part: ot
            id: 1Kgs
            versions: {
                ls: {
                    chapter_exists_count: 5
                    verse_exists_count: 123
                    parse_failure_count: 2
                    parse_ok_count: 3
                    level1_chapter_count: 1
                    level2_chapter_count: 0
                    level3_chapter_count: 2
                    level4_chapter_count: 3
                    level1_verse_count: 123
                    level2_verse_count: 1
                    level3_verse_count: 2
                    level4_verse_count: 23
                }
                ...
            }
        }
        ...
    }
    my %data = ();



SELECT page, revision, parse_errors
FROM
page_id
INNER JOIN revision ON page_latest = rev_id
INNER JOIN parse_errors ON rev_id = revid
WHERE error_occurred = 1;


    my $dbh = DBI->connect('dbi:'.$config->{dbi_url},$config->{dbi_user},$config->{dbi_pw})
        or die "Connection Error: $DBI::errstr\n";
    my $sql = 'insert into bibelwikiparse_errors values('.$dbh->quote($page_id).', '.$dbh->quote($rev_id).', '.$dbh->quote($status).', '.$dbh->quote($desc).');';
    my $sth = $dbh->prepare($sql);


    my $books = LoadFile($fileName);
    $sth->execute
        or die "SQL Error: $DBI::errstr\n";

    for my $book (@$books) {
        my $book = $1;
        my $chapter = $2;
        my $version = $3;
        my $status = $4;
        my $filename = File::Spec->catpath($volume, $directories, $5);

        my $bookEntry = $self->getBook($book);
        if(not defined $bookEntry) {
            debug "Skipping $book, no valid book name.";
            next;
        }
        if (defined $bookEntry->{$chapter}{$version}) {
            debug "Skipping $version $book $chapter, found more than once.";
            next;
        }
        if (not (-f -r -s $filename)) {
            debug "Skipping $filename, check permissions and stuff.";
            next;
        }

        $bookEntry->{chapters}{$chapter}{$version}{book} = $book;
        $bookEntry->{chapters}{$chapter}{$version}{chapter} = $chapter;
        $bookEntry->{chapters}{$chapter}{$version}{version} = $version;
        $bookEntry->{chapters}{$chapter}{$version}{status} = $status;
        $bookEntry->{chapters}{$chapter}{$version}{filename} = $filename;
    }
}

get '/' => sub {
    template 'index';
};

ajax '/lesen/index/buecher' => sub {
    $bookList->books;
};

ajax '/lesen/index/buecher/:book' => sub {
    my $book = $bookList->getBook(params->{book});
    my %bookIndex = ();
    return \%bookIndex if not defined $book;
    
    $bookIndex{name} = $book->{name};
    $bookIndex{chapterCount} = $book->{chapterCount};

    my %chapterIndex = {};
    for(my $chapter = 1; $chapter <= $book->{chapterCount}; $chapter++) {
        my %chapterEntry = {};
        $chapterEntry{number} = $chapter;
        $chapterEntry{sfStatus} =
            defined $book->{chapters}{$chapter}{sf} ? $book->{chapters}{$chapter}{sf}{status} : '-';
        $chapterEntry{lfStatus} =
            defined $book->{chapters}{$chapter}{lf} ? $book->{chapters}{$chapter}{lf}{status} : '-';
        $chapterEntry{lsStatus} =
            defined $book->{chapters}{$chapter}{ls} ? $book->{chapters}{$chapter}{ls}{status} : '-';
        $chapterIndex{$chapter} = \%chapterEntry;
    }
    $bookIndex{chapters} = \%chapterIndex;
    return \%bookIndex;
};

get '/lesen/:book/:chapter' => sub {
    my $bookName = params->{book};
    my $bookIndex = $bookList->getBook($bookName);
    my $chapterNum = params->{chapter};
    my %chapterEntry; {
        if(not exists $bookIndex->{$chapterNum}) {
            %chapterEntry = %{($bookList->getBook('Psalm'))->{chapters}{23}};
        }
        else {
            %chapterEntry = %{$bookIndex->{chapters}{$chapterNum}};
        }
    }
	my $sfText = '';
	my $lfText = '';
	my $lsText = '';
	for my $param (
			[\$sfText, $chapterEntry{sf}],
			[\$lfText, $chapterEntry{lf}],
			[\$lsText, $chapterEntry{ls}],
	) {
		if(defined ${$param}[1]){
			open my $fileHandle, "<:encoding(utf8)", ${$param}[1]{filename};
			${$$param[0]} = do { local $/; <$fileHandle> };
			close $fileHandle;
		}
	}
    template "lesen.tx", {
        page_title => "Offene Bibel: $bookName $chapterNum",
        toplevel_links => <<LINKS,
<li class="active"><a href="#">Lesen</a></li>
<li><a href="#about">News</a></li>
<li><a href="#about">Über uns</a></li>
<li><a href="#contact">Mithelfen</a></li>
LINKS
        plain => $lsText,
        read => $lfText,
        study => $sfText,
    };
};

true;

