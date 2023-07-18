BOOK = $(shell basename "$$(pwd)")

output: $(BOOK).pdf

global: config/bind.sty .switch-gls
.switch-gls:
	@touch -r Makefile .switch-gls
config/bind.sty:
	@git submodule update --init


extracts: images/extracted/town.svg images/extracted/under_lost_city.svg
images/extracted:
	mkdir -p images/extracted
images/extracted/under_lost_city.svg: images/extracted
	inkscape images/Dyson_Logos/under_lost_city.svg --export-id-only --export-id=layer2 -l --export-filename images/extracted/under_lost_city.svg
images/extracted/town.svg: images/extracted
	inkscape images/Dyson_Logos/town.svg --export-id-only --export-id=layer5 -l --export-filename images/extracted/town.svg


svg-inkscape: | config/bind.sty extracts
	@pdflatex -shell-escape -jobname $(BOOK) main.tex
$(BOOK).glo: | svg-inkscape
	@pdflatex -jobname $(BOOK) main.tex
$(BOOK).sls: | $(BOOK).glo
	@makeglossaries $(BOOK)
$(BOOK).pdf: $(BOOK).sls
	@pdflatex -jobname $(BOOK) main.tex

handouts.pdf: handouts.tex
	pdflatex -shell-escape handouts.tex
	pdflatex handouts.tex
creds:
	cd images && pandoc artists.md -o ../art.pdf

all: $(BOOK).pdf handouts.pdf
	latexmk -jobname=$(BOOK) -shell-escape -pdf main.tex

clean:
	rm -fr *.aux *.sls *.slo *.slg *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf sq/*aux svg-inkscape \
	images/extracted

.PHONY: clean all extracts
