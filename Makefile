DOWNLOADABLES=dump.tar.gz
GENERATABLES=dump_newest_only.txt glyphs.txt
TARGETS=$(GENERATABLES) $(DOWNLOADABLES)

.PHONY: all fetch clean distclean
all: $(TARGETS)

fetch: $(DOWNLOADABLES)

kagebold.js: kage.js kagebold.patch
	patch -o $@ -r /dev/null $^

dump.tar.gz:
	wget -O $@ http://glyphwiki.org/dump.tar.gz

dump_newest_only.txt: dump.tar.gz
	tar xfz $< $@ && touch $@

glyphs.txt: kana.txt jisx0208-level-1.txt
	cat $^ | sort | uniq > $@

clean:
	-rm $(GENERATABLES)

distclean:
	-rm $(TARGETS)
