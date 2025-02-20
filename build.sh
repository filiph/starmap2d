#!/bin/bash

# Any subsequent commands which fail will cause the shell script to exit
# immediately.
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

mkdir -p starmap2d-bundle/sectors
mkdir -p starmap2d-bundle/sectors-no-tiles

python build.py "$@"

cd starmap2d-bundle/ && ../svg2pdf.sh ./*.svg

cd sectors && ../../svg2pdf.sh ./*.svg

cd ../

cd sectors-no-tiles && ../../svg2pdf.sh ./*.svg

cd ../../

jekyll build -s ./jekyll -d ./appengine/static

mkdir -p ./appengine/static/download

/Applications/Inkscape.app/Contents/MacOS/inkscape \
  --export-filename="$DIR/appengine/static/download/poster.png" \
  --export-width=5400 $DIR/starmap2d-bundle/poster.svg

cp ./starmap2d-bundle/poster.pdf ./appengine/static/download/
cp ./starmap2d-bundle/stars.csv ./appengine/static/download/
cp ./starmap2d-bundle/*.md ./appengine/static/download/

zip -r -X -9 ./appengine/static/download/bundle-latest.zip \
  ./starmap2d-bundle/*.pdf ./starmap2d-bundle/**/*.pdf \
  ./starmap2d-bundle/*.md ./starmap2d-bundle/*.csv
