output: main.pdf

.PHONY: book
main.pdf: main.aux config $(wildcard *tex)
	pdflatex main.tex
main.aux: svg-inkscape
	pdflatex main.tex
	makeglossaries main
svg-inkscape: config/bind.sty images extracts
	pdflatex -shell-escape main.tex
	pdflatex main.tex

.PHONY : extracts
extracts: images/extracted/town.svg images/extracted/under_lost_city.svg

images/extracted:
	mkdir -p images/extracted
images/extracted/under_lost_city.svg: images/extracted
	inkscape images/Dyson_Logos/under_lost_city.svg --export-id-only --export-id=layer2 -l --export-filename images/extracted/under_lost_city.svg
images/extracted/town.svg: images/extracted
	inkscape images/Dyson_Logos/town.svg --export-id-only --export-id=layer5 -l --export-filename images/extracted/town.svg

config/bind.sty:
	git submodule update --init

handouts.pdf:
	pdflatex -shell-escape handouts.tex
	pdflatex handouts.tex

creds:
	cd images && pandoc artists.md -o ../art.pdf

mim.pdf: main.pdf
	mv main.pdf mim.pdf

all: mim.pdf handouts.pdf

clean:
	rm -fr *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf  *.slg  *.slo  *.sls  svg-inkscape
