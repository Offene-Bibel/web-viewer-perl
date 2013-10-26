Todos
=====

- Die *Über uns* Seite. Entweder direkt in Bootstrap, oder über Drupal. Falls direkt in Bootstrap, dann irgend ein schönes Design ausdenken und umsetzen. Hier kann man ziemlich gut kopieren: [Bootstrapbeispiele](http://getbootstrap.com/getting-started/#examples) Ich denke der Inhalt sollte maximal 1-2 Bildschirmseiten sein. Im Zweifel lieber weniger.
- Anbindung an Drupal. Notwendig für den Blog. Ein Theme für Drupal das genau so aussieht wäre super. Ein bis maximal zweispaltig würde ich vorschlagen. Entweder nur den Blog, aber keine Vorschau, sondern direkt die kompletten Einträge, oder den Blog in einem großen Block (Breite 8 oder 9 laut Gridsystem) und daneben in klein die Twitterchangelogs (Breite 4 oder 3). Dieser Punkt ist warscheinlich etwas mehr Arbeit.
- Die *Mithelfen* Seite. Anbindung der Wiki. Ich vermute es gibt eine Art globales Wikitemplate, in dem das Gesamtlayout der aktuellen offenen-bibel.de drin ist. Bei dem Layout oben die Leiste mit dazubauen.
- Die *Lesen* Seite verbessern. Da gibt's viele Sachen.
    - Das Layout für die Kapitelauswahl bauen.
    - Indikatoren für den Status der Fassungen einbauen + Hoverover mit Erklärung.
    - Bei Optionen einbauen, Versnummern und Alternativen auszuschalten.
    - Hilfeknopf, der erklärt was [] {} () ℘ 〈a〉 bedeutet. Evenutell auch kurze Erklärung von *Leichte Sprache*, *Lesefassung*, *Studienfassung*.
- Backend *(patzim)*

Backend
-------
The backend is driven by pre generated html fragments created using the converter. It expects folder containing one file for each chapter and version. An index of all such files has to be given in a status file. There can be more than one status file.

### status file
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
`/lesen/Könige1_3?verse=3`

