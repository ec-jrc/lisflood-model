#!/usr/bin/env bash

# Dependencies:
# pandoc > 2.0
#  - On Ubuntu 18.04, install latest pandoc deb package from https://github.com/jgm/pandoc/releases
# texlive and xelatex pdf engine
#  - Install texlive packages: sudo apt-get -y install texlive-xetex texlive-latex-recommended texlive-pictures texlive-latex-extra
# gs script

yaml_header="---
  # ...
  header-includes:
    - \newcommand{\gt}{>}
    - \newcommand{\lt}{<}
  # ...
---
"

mkdir -p ./_pdf/
mkdir -p ./_pdf/media
rm ./_pdf/*.md 2> /dev/null
rm ./_pdf/*.pdf 2> /dev/null
rm ./_pdf/media/* 2> /dev/null
cp -R ./media/* ./_pdf/media/

for dir in ./_site/*;
do
  if [[ -d "${dir}" && ! -L "${dir}" ]]; then
    dir=${dir%*/}
    fin=${dir##*/}
    if [[ "$fin" != "media" && "$fin" != "assets" && "$fin" != "index_pdf" ]]; then
      echo "-----> ${fin}"
      cp ${dir}/index.md ./_pdf/${fin}.md
      sed -i 's#\.\./media/#\./media/#g' ./_pdf/${fin}.md
    fi
  fi
done

echo "pandoc index_pdf.md --template=template.latex -f markdown+smart -o _pdf/frontpage.pdf -V geometry:margin=1.5cm"
pandoc index_pdf.md --template=template.latex -f markdown+smart -o _pdf/frontpage.pdf -V geometry:margin=1.5cm

echo "pandoc _pdf/*.md --toc -V toc-title:"Table of Contents" --template=template.latex --read=markdown+smart --write=pdf --pdf-engine=xelatex -o _pdf/manual.pdf -V geometry:margin=1.5cm"
pandoc _pdf/*.md --toc -V toc-title:"Table of Contents" --template=template.latex --read=markdown+smart --write=pdf --pdf-engine=xelatex -o _pdf/manual.pdf -V geometry:margin=1.5cm

echo "gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dAutoRotatePages=/None -sOutputFile=./_pdf/Lisflood_Model.pdf ./_pdf/frontpage.pdf ./_pdf/manual.pdf"
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dAutoRotatePages=/None -sOutputFile=./_pdf/Lisflood_Model.pdf ./_pdf/frontpage.pdf ./_pdf/manual.pdf

cp ./_pdf/Lisflood_Model.pdf ./
cp ./_pdf/Lisflood_Model.pdf ./_site/
