include config/vars

all: $(RELEASE)

config/vars:
	@git submodule update --init

EXTRACTS = images/extracted/town.svg images/extracted/shadow_gate_map.svg

images/extracted:
	mkdir -p images/extracted
images/extracted/town.svg: images/extracted
	inkscape images/Dyson_Logos/town.svg --export-id-only --export-id=layer5 -l --export-filename images/extracted/town.svg
images/extracted/shadow_gate_map.svg:| images/extracted
	inkscape images/Dyson_Logos/shadow_gate.svg --export-id-only --export-id=layer1 -l --export-filename images/extracted/shadow_gate_map.svg

$(DBOOK): $(EXTRACTS) EXTERNAL LOCTEX STYLE_FILES forest threads raising roads storm tailend town | qr.tex
	@$(COMPILER) main.tex

images/extracted/cover.jpg: images/Irina/greylands.jpg images/extracted/inclusion.tex
	$(CP) $< $@
$(DROSS)/$(BOOK)_cover.pdf: config/cover.tex cover.tex images/extracted/cover.jpg $(DBOOK)
	$(RUN) -jobname $(BOOK)_cover $<
cover.pdf: $(DROSS)/$(BOOK)_cover.pdf
	$(CP) $< $@

creds:
	cd images && pandoc artists.md -o ../art.pdf

clean:
	$(CLEAN) $(EXTRACTS)
