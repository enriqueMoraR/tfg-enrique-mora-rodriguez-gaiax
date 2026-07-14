TFG LaTeX project (ESI template)

Estructura breve:

- main.tex: documento principal (usa \documentclass{esi-tfg})
- metadata.tex: metadatos (autor, director, título, fecha)
- figures/: imágenes y diagramas (no incluidas)
- references.bib: bibliografía (crear según necesites)

Instrucciones rápidas para compilar (recomendado instalar paquete esi-tfg):

1) Usando sistema (si esi-tfg instalado):
   pdflatex main.tex && bibtex main || biber main && pdflatex main.tex && pdflatex main.tex

2) Usando Overleaf: crear nuevo proyecto y subir toda la carpeta /plan/tfg

3) Si no tienes esi-tfg instalado, instala texlive y dependencias o cambia a article/report class temporalmente.

Contenido inicial extraído del README del proyecto. Edita main.tex y metadata.tex para completar secciones y añadir figuras, tablas y referencias.
