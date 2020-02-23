# LaTeX Vorlage

LaTeX Template, nach den Anforderungen der DHBW Stuttgart, Fakultät Wirtschaft. 
Dieses Template basiert auf dem offiziellen Template der DHBW Stuttgart von Prof. Dr. Straub.

# Notwendige/ Empfohlene Tools

Nachfolgend sind Tools aufgelistet, welche vom Team erfolgreich gestestet und empfohlen wurden.

### LaTeX Distribution:

**Mac**
- [MacTeX](https://tug.org/mactex/mactex-download.html "MacTeX Download Seite")

**Windows** ([Zusätzlich wird hier Perl benötigt](http://strawberryperl.com/ "Perl for Windows"))
- [MiKTeX](https://miktex.org/download "MiKTeX Download Seite")

### LaTeX Editor:
- [Visual Studio Code](https://code.visualstudio.com/ "Visual Studio Code Download Seite"), mit der Erweiterung **"LaTeX Workshop"** und **"German - Code Spell Checker"**

### Literaturverwaltung:
- Mendeley

# Notwendige Anpassungen

### master.tex
- Einbinden der eigenen Literaturdatenbank (Datei: tables/literaturverzeichnis.bib ersetzen)
- Eigene Gespräche müssen manuell in das Gesprächsverzeichnis (Datei: tables/gespraechsverzeichnis.bib bearbeiten) eingefügt werden. Hierzu kann der Mustereintrag in der Datei als Vorlage verwendet werden
- (Optional) Einbinden eines Abstracts. Hierzu müssen die zwei Zeilen unter dem Kommentar "Einbinden eines Abstracts (optional)" einkommentiert werden. Anschließend kann das Abstract in die bereits vorbereitete Datei (Datei: main/abstract.tex bearbeiten) eingefügt werden.
- Eigene Abkürzungen müssen manuell dem Abkürzungsverzeichnis (Datei: tables/abkuerzungen.tex) hinzugefügt werden. Hier kann ebenfalls nach den Beispieleinträgen vorgegangen werden.
- Die Einträge im Inhaltsverzeichnis, Abbildungsverzeichnis und Tabellenverzeichnis werden automatisch generiert. Hier muss jedoch das Format aus dem cheat_sheet, bei Tabellen und Bildern, eingehalten werden. Sollten diese Verzeichnisse nicht benötigt werden muss der Codeblock, wo diese definiert werden, komplett auskommentiert/ entfernt werden.
- Im nachfolgenden können nun eigene Subfiles für den eigentlichen Inhalt, unter den jeweiligen Abschnitten eingefügt werden. Hier kann sich am cheat_sheet orientiert werden.
- Der Anhang ist bereits vorbereitet. Hier können dann eigene Inhalten nach dem Muster in der Datei (Datei: anhang/anhang.tex bearbeiten) hinzugefügt werden.
- Zuletzt muss noch die Zeile für das korrekte Quellenverzeichnis (Mit oder ohne Gesprächsverzeichnis) auskommentiert werden.

### dhbw_vorlagen/deckblatt.tex
- Hier muss zunächst der Typ der Arbeit ausgewählt werden. Dazu muss einer der voreingestellten Typen auskommentiert werden oder es kann ein benutzerdefinierter Typ festgelegt werden
- Es müssen außerdem ein Thema und ein Unterthema eingetragen werden. Sollte kein Unterthema benötigt werden, muss die Bezeichnung für das Unterthema leer gelassen werden (Die Zeile darf nicht komplett gelöscht werden, weil hier dann weitere Anpassungen nötig wären!)
- Ein Autor muss ebenfalls eingetragen werden
- Unter Umständen muss das Datum der Abgabe geändert werden (Standardmäßig wird das aktuelle Datum verwendet)
- Der Kurs, Name der/des Betreuers/in und der/des Studiengangsleiters/in müssen angepasst werden
- Sollte ein Sperrvermerk benötigt werden, müssen die entsprechenden Zeilen einfach auskommentiert werden
- Unten werden noch die Metadaten festgelegt. Hier ist im Normalfall keine Anpassung notwendig. Hier sollte, je nach Version, jedoch das Datum des Copyrights überprüft werden.

