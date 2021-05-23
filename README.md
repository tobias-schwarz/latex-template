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

### main.tex

- Einbinden der eigenen Literaturdatenbank (Datei: `lib/bibliography.bib` ersetzen)
- (Optional) Einbinden eines Abstracts. Hierzu müssen die zwei Zeilen unter dem Kommentar "Einbinden eines Abstracts (optional)" einkommentiert werden. Anschließend kann das Abstract in die bereits vorbereitete Datei (Datei: `src/abstract.tex` bearbeiten) eingefügt werden.
- Eigene Abkürzungen müssen manuell dem Abkürzungsverzeichnis (Datei: `lib/tables/abkuerzungen.tex`) hinzugefügt werden. Hier kann ebenfalls nach den Beispieleinträgen vorgegangen werden.
- Die Einträge im Inhaltsverzeichnis, Abbildungsverzeichnis und Tabellenverzeichnis werden automatisch generiert. Hier muss jedoch das Format aus der `examples/cheat_sheet.tex` bei Tabellen und Bildern eingehalten werden. Sollten diese Verzeichnisse nicht benötigt werden muss der Codeblock, wo diese definiert werden, komplett auskommentiert/ entfernt werden.
- Im nachfolgenden können nun eigene Subfiles für den eigentlichen Inhalt eingefügt werden. Hier kann sich an den beispielhaften Dateien im Ordner `examples` orientiert werden.
- Der Anhang ist bereits vorbereitet. Hier können dann eigene Inhalten nach dem Muster in der Datei (Datei: `src/appendix/appendix.tex` bearbeiten) hinzugefügt werden.
- Es sollte zur Abgabe darauf geachtet werden dass die Dateien aus dem Ordner `examples`, die `release_notes.tex` und ggf. weitere beispielhafte Inhalte auskommentiert oder gelöscht werden.

### src/config.tex

- Hier werden die Konfigurationen für die Arbeit (Title, Kurs, etc.) angepasst.
- Entsprechende Beispiele und Definition/Erklärung sind in der Datei verfügbar.
