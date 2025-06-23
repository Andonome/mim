EXTERNAL_REFERENTS = core stories judgement

local_directories = threads raising storm tailend town roads forest

local_texfiles = $(foreach dir, $(local_directories), \
	$(wildcard $(dir)/*) \
)

DEPS += $(local_texfiles)

dependencies += magick

include config/common.mk

all: $(RELEASE)

config/common.mk:
	@git submodule update --init

SVG_EXTRACTS = town shadow_gate_map
EXTRACTS += $(patsubst %, images/extracted/%.svg, $(SVG_EXTRACTS))
JPG_EXTRACTS = bandit_camp town_wide lochside redfall old_temple basement cinderfilch sixshadow gorge
EXTRACTS += $(patsubst %, images/extracted/%.jpg, $(JPG_EXTRACTS))

images/extracted/%: images/extracted/

images/extracted/town.svg: images/Dyson_Logos/town.svg
	inkscape $< --export-id-only --export-id=layer5 -l --export-filename $@
images/extracted/shadow_gate_map.svg: images/Dyson_Logos/shadow_gate.svg
	inkscape $< --export-id-only --export-id=layer1 -l --export-filename $@

$(DBOOK): $(DEPS) $(EXTRACTS) $(AUX_REFERENCES) qr.tex

images/extracted/bandit_camp.jpg: images/Irina/greylands.jpg
	magick $< -crop 1000x250+20+160 $@
images/extracted/town_wide.jpg: images/Irina/greylands.jpg
	magick $< -crop 1400x210+200+200 $@
images/extracted/lochside.jpg: images/Irina/greylands.jpg
	magick $< -crop 1000x170+600+310 $@
images/extracted/redfall.jpg: images/Irina/greylands.jpg
	magick $< -crop 1000x150+250+340 $@
images/extracted/old_temple.jpg: images/Irina/greylands.jpg
	magick $< -crop 900x100+10+640 $@
images/extracted/basement.jpg: images/Irina/greylands.jpg
	magick $< -crop 1000x130+10+30 $@
images/extracted/cinderfilch.jpg: images/Irina/greylands.jpg
	magick $< -crop 1000x130+594+50 $@
images/extracted/sixshadow.jpg: images/Irina/greylands.jpg
	magick $< -crop 1000x130+590+600 $@
images/extracted/gorge.jpg: images/Irina/greylands.jpg
	magick $< -crop 1000x140+600+530 $@

images/extracted/cover.jpg: images/Unknown/sixshadow.jpg | images/extracted/
	$(CP) $< $@
$(DROSS)/$(BOOK)_cover.pdf: config/share/cover.tex cover.tex images/extracted/cover.jpg $(DBOOK)
	$(RUN) -jobname $(BOOK)_cover $<
cover.pdf: $(DROSS)/$(BOOK)_cover.pdf
	$(CP) $< $@

targets += cover.pdf

images/extracted/necromancer.png: images/Decky/necromancer.svg
	magick $< $@

.PHONY: creds
creds: art.pdf ## Arist showcase
art.pdf: images/extracted/necromancer.png
	cd images && pandoc artists.md -o ../art.pdf

output += art.pdf
