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
- main.css in verschiedene .css aufsplitten, um Mobile First umzusetzen
- JavaScript von click-Events lösen, da dieses Einsatz der Maus voraussetzen (schließt Tastatur und alternative Eingabegeräte aus!)
    - Dies steigert die Performance (es werden nur relevante Dateien) geladen
    - Daneben wird das Projekt wartungsärmer (?)
- Manifest-Datei schreiben, damit das Projekt als Webapp bedienbar ist

