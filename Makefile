include config/vars

all: $(RELEASE)

config/vars:
	@git submodule update --init

EXTRACTS = images/extracted/town.svg images/extracted/under_lost_city.svg images/extracted/shadow_gate_map.svg

images/extracted:
	mkdir -p images/extracted
images/extracted/under_lost_city.svg: images/extracted
	inkscape images/Dyson_Logos/under_lost_city.svg --export-id-only --export-id=layer2 -l --export-filename images/extracted/under_lost_city.svg
images/extracted/town.svg: images/extracted
	inkscape images/Dyson_Logos/town.svg --export-id-only --export-id=layer5 -l --export-filename images/extracted/town.svg
images/extracted/shadow_gate_map.svg:| images/extracted
	inkscape images/Dyson_Logos/shadow_gate.svg --export-id-only --export-id=layer1 -l --export-filename images/extracted/shadow_gate_map.svg

$(DBOOK): $(EXTRACTS) EXTERNAL LOCTEX STYLE_FILES forest intro raising roads storm tailend town | qr.tex
	@$(COMPILER) main.tex

creds:
	cd images && pandoc artists.md -o ../art.pdf

clean:
	$(CLEAN) $(EXTRACTS)
