![Quellen](https://img.shields.io/static/v1?label=Quellen&message=1&color=red&logo=adobe-acrobat-reader&style=for-the-badge)
![Seiten](https://img.shields.io/static/v1?label=Seiten&message=&color=blue&logo=LibreOffice&style=for-the-badge)
![Progress](https://img.shields.io/static/v1?label=Progress&message=&color=yellow&logo=LibreOffice&style=for-the-badge)
![Last update](https://img.shields.io/static/v1?label=Last%20Update&message=Tue%20Feb%2025%2012:22:23%20UTC%202020&color=green&logo=Clockify&style=for-the-badge)

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
- Einbinden der eigenen Literaturdatenbank (Datei: `bibliography/bibliography.bib` ersetzen)
- Alternativ können die Quellen manuel unter dem Verzeichnis `bibliography/literature` gepflegt werden.
- (Optional) Einbinden eines Abstracts. Hierzu müssen die zwei Zeilen unter dem Kommentar "Einbinden eines Abstracts (optional)" einkommentiert werden. Anschließend kann das Abstract in die bereits vorbereitete Datei (Datei: `abstract.tex` bearbeiten) eingefügt werden.
- Eigene Abkürzungen müssen manuell dem Abkürzungsverzeichnis (Datei: `tables/abkuerzungen.tex`) hinzugefügt werden. Hier kann ebenfalls nach den Beispieleinträgen vorgegangen werden.
- Die Einträge im Inhaltsverzeichnis, Abbildungsverzeichnis und Tabellenverzeichnis werden automatisch generiert. Hier muss jedoch das Format aus der `cheat_sheet.tex` bei Tabellen und Bildern eingehalten werden. Sollten diese Verzeichnisse nicht benötigt werden muss der Codeblock, wo diese definiert werden, komplett auskommentiert/ entfernt werden.
- Im nachfolgenden können nun eigene Subfiles für den eigentlichen Inhalt eingefügt werden. Hier kann sich an der `cheat_sheet.tex` und an den Beispielhaften Dateien im Ordner `examples` orientiert werden.
- Der Anhang ist bereits vorbereitet. Hier können dann eigene Inhalten nach dem Muster in der Datei (Datei: `appendix/appendix.tex` bearbeiten) hinzugefügt werden.
- Es sollte zur Abgabe darauf geachtet werden dass die `cheat_sheet.tex`, Dateien auf dem Ordner `examples`, die `release_notes.tex` und ggf. weitere Beispielhafte Inhalte auskommentiert oder gelöscht werden.

### deckblatt.tex
- Hier muss zunächst der Typ der Arbeit ausgewählt werden. Dazu muss einer der voreingestellten Typen auskommentiert werden oder es kann ein benutzerdefinierter Typ festgelegt werden
- Es müssen außerdem ein Thema und ein Unterthema eingetragen werden. Sollte kein Unterthema benötigt werden, muss die Bezeichnung für das Unterthema leer gelassen werden (Die Zeile darf nicht komplett gelöscht werden, weil hier Abhängigkeiten bestehen)
- Ein/e Autor*in muss ebenfalls eingetragen werden
- Unter Umständen muss das Datum der Abgabe geändert werden (Standardmäßig wird das aktuelle Datum verwendet)
- Der Kurs, Name der/des Betreuers/in und der/des Studiengangsleiters/in müssen angepasst werden.
- Sollte ein Sperrvermerk benötigt werden, müssen die entsprechenden Zeilen einfach auskommentiert werden.

