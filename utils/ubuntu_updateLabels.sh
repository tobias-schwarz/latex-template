echo Moving to literatur...
cd ..
cd bibliography
cd literatur

echo Counting files...
NOFFILES=`ls -1 | wc -l`
NO_WHITESPACE="$(echo -e "${NOFFILES}" | tr -d '[:space:]')"

echo $NO_WHITESPACE files found. Moving to README...
cd ..
cd ..

echo Replacing label...
sed -i "s/^!\[Quellen.*/![Quellen](https:\/\/img.shields.io\/static\/v1\?label=Quellen\&message=${NO_WHITESPACE}\&color=red\&logo=adobe-acrobat-reader\&style=for-the-badge)/" README.md

echo Done

cd utils

echo Starting python script to count pages...
python3 getPages.py

echo Reading result...
inputPages="pages.txt"
while IFS= read -r line
do
    page=$line
done < "$inputPages"

inputProg="progress.txt"
while IFS= read -r line
do
    progress=$line
done < "$inputProg"

echo Replacing label with $page...
cd ..
sed -i "s/^!\[Seiten.*/![Seiten](https:\/\/img.shields.io\/static\/v1\?label=Seiten\&message=${page}\&color=blue\&logo=LibreOffice\&style=for-the-badge)/" README.md

sed -i "s/^!\[Progress.*/![Progress](https:\/\/img.shields.io\/static\/v1\?label=Progress\&message=${progress}\&color=yellow\&logo=LibreOffice\&style=for-the-badge)/" README.md

currentDate=`date`
echo $currentDate
curDate=${currentDate// /\%20}
sed -i "s/^!\[Last update.*/![Last update](https:\/\/img.shields.io\/static\/v1\?label=Last\%20Update\&message=${curDate}\&color=green\&logo=Clockify\&style=for-the-badge)/" README.md

echo Done