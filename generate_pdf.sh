#!/usr/bin/env bash
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
rm ./_pdf/media/* 2> /dev/null
cp -R ./media/* ./_pdf/media/

for dir in ./_site/*;
do
  if [[ -d "${dir}" && ! -L "${dir}" ]]; then
    dir=${dir%*/}
    fin=${dir##*/}
    if [[ "$fin" != "media" && "$fin" != "assets" && "$fin" != "index_old" && "$fin" != "everything" && "$fin" != "index_UserGuide" ]]; then
      echo "-----> ${fin}"
      cp ${dir}/index.md ./_pdf/${fin}.md
      sed -i 's#\.\./media/#\./media/#g' ./_pdf/${fin}.md
#      if [[ "$fin" == "2_stdLISFLOOD_atmospheric-processes" || "$fin" == "2_stdLISFLOOD_soilmoisture-redistribution" || "$fin" == "2_stdLISFLOOD_vertical-processes" || "$fin" == "3_optLISFLOOD_reservoirs" || "$fin" == "2_stdLISFLOOD_interception" ]]; then
#      if [[ "$fin" == "0_disclaimer" ]]; then
#        echo "Adding YAML header to ${fin} for pandoc pdf generation when gt is used in formulas"
#        echo ${yaml_header} | cat - ./_pdf/${fin}.md > ./_pdf/temp.md && mv ./_pdf/temp.md ./_pdf/${fin}.md
#      fi
    fi
  fi
done

echo "pandoc _pdf/*.md --normalize --smart --toc -V toc-title:"Table of Contents" --template=template.latex -f markdown+tex_math_dollars+tex_math_single_backslash --latex-engine=xelatex -o _pdf/Lisflood_Model.pdf -V geometry:margin=1.5cm"
pandoc _pdf/*.md --normalize --smart --toc -V toc-title:"Table of Contents" --template=template.latex -f markdown+tex_math_dollars+tex_math_single_backslash --latex-engine=xelatex -o _pdf/Lisflood_Model.pdf -V geometry:margin=1.5cm

cp ./_pdf/Lisflood_Model.pdf ./
cp ./_pdf/Lisflood_Model.pdf ./_site/
