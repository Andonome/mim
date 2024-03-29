BOOK = $(shell basename "$$(pwd)")
QR_TARGET = $(shell grep 'mailto' README.md | cut -d' ' -f3)

output: $(BOOK).pdf

global: config/bind.sty .switch-gls
.switch-gls:
	@touch -r Makefile .switch-gls
config/bind.sty:
	@git submodule update --init


.PHONY : extracts
extracts: images/extracted/town.svg images/extracted/under_lost_city.svg images/extracted/shadow_gate_map.svg

images/extracted:
	mkdir -p images/extracted
images/extracted/under_lost_city.svg: images/extracted
	inkscape images/Dyson_Logos/under_lost_city.svg --export-id-only --export-id=layer2 -l --export-filename images/extracted/under_lost_city.svg
images/extracted/town.svg: images/extracted
	inkscape images/Dyson_Logos/town.svg --export-id-only --export-id=layer5 -l --export-filename images/extracted/town.svg
images/extracted/shadow_gate_map.svg:| images/extracted
	inkscape images/Dyson_Logos/shadow_gate.svg --export-id-only --export-id=layer3 -l --export-filename images/extracted/shadow_gate_map.svg

qr.tex: README.md
	@echo '\qrcode[height=.2\\textwidth]{$(QR_TARGET)}' > qr.tex
svg-inkscape: | config/bind.sty extracts qr.tex
	@pdflatex -shell-escape -jobname $(BOOK) main.tex
$(BOOK).pdf: svg-inkscape $(wildcard *.tex) $(wildcard config/*.sty)
	@pdflatex -jobname $(BOOK) main.tex

creds:
	cd images && pandoc artists.md -o ../art.pdf

all: $(BOOK).pdf
	latexmk -jobname=$(BOOK) -shell-escape -pdf main.tex

clean:
	rm -fr *.aux *.sls *.slo *.slg *.toc *.acn *.log *.ptc *.out *.idx *.ist \
	*glg \
	*gls \
	*.acr *.alg *.ilg *.ind *.pdf sq/*aux svg-inkscape \
	*glo \
	*latexmk \
	*.fls \
	qr.tex \
	images/extracted

.PHONY: clean all extracts
