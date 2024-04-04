include config/vars

output: $(BOOK).pdf

config/vars:
	@git submodule update --init
.switch-gls:
	@touch -r Makefile .switch-gls

EXTRACTS = images/extracted/town.svg images/extracted/under_lost_city.svg images/extracted/shadow_gate_map.svg

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
$(BOOK).pdf: $(wildcard *.tex) $(wildcard config/*.sty) config/vars $(EXTRACTS) qr.tex
	@$(COMPILER) main.tex

creds:
	cd images && pandoc artists.md -o ../art.pdf

all: $(BOOK).pdf

clean:
	$(CLEAN)
