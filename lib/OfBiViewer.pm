package OfBiViewer;
use Dancer2;

our $VERSION = '0.1';

=pod
get '/' => sub {
    template 'index';
};
=cut

get '/lesen/:chapter' => sub {
	my $chapterNum = params->{chapter};
    template "lesen.tx", {
		page_title => $chapterNum,
		toplevel_links => <<LINKS,
<li class="active"><a href="#">Lesen</a></li>
<li><a href="#about">News</a></li>
<li><a href="#about">Über uns</a></li>
<li><a href="#contact">Mithelfen</a></li>
LINKS
		plain => "Leichte Sprache Text: $chapterNum",
		read => "Lesefassung Text",
		study => "Studienfassung Text",
	};
};

true;
