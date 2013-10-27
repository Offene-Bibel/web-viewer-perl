package OfBiViewer;
use 5.014_001;
use strict;
use utf8;

use Dancer2;
use String::Util 'hascontent';
use File::Spec;

our $VERSION = '0.1';

=pod
%index{Matthäus_5}{lf}{filename};
=cut
my %index = ();
{
    use Data::Dumper;
    my @indexFilenames = @{config->{indexes}};
    for my $indexFilename (@indexFilenames) {
        my ($volume, $directories, $file) = File::Spec->splitpath( $indexFilename );
        open my $indexFile, "<:encoding(utf8)", $indexFilename or die "Index file not found: $indexFilename: $!";
        while (my $line = <$indexFile>) {
            next if $line =~ /^#/ or not hascontent $line;
            if ($line =~ /^(\w+) (\d+) (sf|lf|ls) (\d) (\w+)$/) {
                my %entry = (
                    book => $1,
                    chapter => $2,
                    version => $3,
                    status => $4,
                    filename => File::Spec->catpath($volume, $directories, $5),
                );
                my $key = $entry{book} . '_' . $entry{chapter};
                if (not (-f -r -s $entry{filename})) {
                    say "Skipping $entry{filename}, check permissions and stuff.";
                    next;
                }
                #$index{$key} = \{} if not defined $index{$key};
                $index{$key}{$entry{version}} = \%entry;
            }
            else {
                die "Line $. in file $indexFilename is not valid. Aborting.";
            }
        }
        close $indexFile;
    }
    die "No usable content given. Aborting." if not %index;
}

get '/' => sub {
    template 'index';
};

get '/lesen/:chapter' => sub {
    my $chapterNum = params->{chapter};
    my %chapterEntry; {
        if(not exists $index{$chapterNum}) {
            my ($key, $value) = each %index;
            %chapterEntry = %$value;
        }
        else {
            %chapterEntry = %{$index{$chapterNum}};
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
        page_title => $chapterNum,
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

