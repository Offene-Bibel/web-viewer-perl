Offene Bibel Viewer
===================

Installation
------------

Requirements are:

- Perl version 5.12.4 or higher.
- Following CPAN modules: Dancer2, Dancer2::Plugins::Ajax, String::Util, Moo. You can install all these modules using `perl -MCPAN -e 'install Dancer2 Dancer2::Plugins::Ajax String::Util Moo'`
- A set of generated chapter files and a respective index. This can be downloaded here: <https://www.dropbox.com/s/r8frpmkipx5ey0v/webResults.zip>. Alternatively you can generate them yourself using the [converter](https://gitorious.org/offene-bibel-converter/offene-bibel-converter).
- The viewer itself. You can either download it [here](https://gitorious.org/offene-bibel-converter/web-viewer) (Download button is at the top right) or clone it using git: `git clone git@gitorious.org:offene-bibel-converter/web-viewer.git`.

Before the first start, you have to extract or generate the chapter files. In the *config.yml* file adapt the `indexes:` path. You need to change the path to point at the index file in the chapters folder.

Starting the program is done with: `./bin/app.pl`. If all goes well you can point your browser at <http://localhost:3000/lesen/Psalm/23> and should see something.


Todos
-----

- Die *Über uns* Seite. Entweder direkt in Bootstrap, oder über Drupal. Falls direkt in Bootstrap, dann irgend ein schönes Design ausdenken und umsetzen. Hier kann man ziemlich gut kopieren: [Bootstrapbeispiele](http://getbootstrap.com/getting-started/#examples) Ich denke der Inhalt sollte maximal 1-2 Bildschirmseiten sein. Im Zweifel lieber weniger.
- Anbindung an Drupal. Notwendig für den Blog. Ein Theme für Drupal das genau so aussieht wäre super. Ein bis maximal zweispaltig würde ich vorschlagen. Entweder nur den Blog, aber keine Vorschau, sondern direkt die kompletten Einträge, oder den Blog in einem großen Block (Breite 8 oder 9 laut Gridsystem) und daneben in klein die Twitterchangelogs (Breite 4 oder 3). Dieser Punkt ist warscheinlich etwas mehr Arbeit. *(patzim)*
- Die *Mithelfen* Seite. Anbindung der Wiki. Ich vermute es gibt eine Art globales Wikitemplate, in dem das Gesamtlayout der aktuellen offenen-bibel.de drin ist. Bei dem Layout oben die Leiste mit dazubauen.
- Die *Lesen* Seite verbessern.
    - Das Layout für die Kapitelauswahl bauen.
    - Indikatoren für den Status der Fassungen einbauen + Hoverover mit Erklärung.
    - Bei Optionen einbauen, Versnummern und Alternativen auszuschalten.
    - Hilfeknopf, der erklärt was [] {} () ℘ 〈a〉 bedeutet. Evenutell auch kurze Erklärung von *Leichte Sprache*, *Lesefassung*, *Studienfassung*.
- Backend *(patzim)*


Technical
---------

The backend is driven by pre generated html fragments created using the converter. It expects a folder containing one file for each chapter and version. An index of all such files has to be given in an index file. There can be more than one index file.

### index file
Each line corresponds to a chapter in a translation. Format is: `book chapter translation status filename`. Lines started with `#` are treated as comments.

    ...
    Matthäus 12 sf 3 Matthäus_12_sf
    Matthäus 12 lf 0 Matthäus_12_lf
    Matthäus 12 ls 4 Matthäus_12_ls
	# A comment.
    Matthäus 13 sf 1 Matthäus_12_sf
    ...

Status can be one of the following:

- 0 = existiert nicht
- 1 = teilweise übersetzt
- 2 = Rohübersetzung
- 3 = fast fertig
- 4 = fertig

### URL format
`/lesen/Matthäus_3`
`/lesen/1_Könige_3?verse=3`

