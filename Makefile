SUBDIRS=mincho1 mincho3 mincho5 mincho7
DOWNLOADABLES=dump.tar.gz
GENERATABLES=dump_newest_only.txt glyphs.txt $(SUBDIRS)
TARGETS=$(GENERATABLES) $(DOWNLOADABLES)

.PHONY: all fetch clean distclean $(SUBDIRS)
all: $(TARGETS)

fetch: $(DOWNLOADABLES)

kagebold.js: kage.js kagebold.patch
	patch -o $@ -r /dev/null $^

dump.tar.gz:
	wget -O $@ http://glyphwiki.org/dump.tar.gz

dump_newest_only.txt: dump.tar.gz
	tar xfz $< $@ && touch $@

glyphs.txt: 7bit-ascii.txt kana.txt jisx0208-level-1.txt
	cat $^ | sort | uniq > $@

mincho1/Makefile: dump_newest_only.txt glyphs.txt
	mkdir -p mincho1
	./mkmkfile.rb mincho1.ttf 1 "HZ Mincho" "Light" "HZ 明朝" "細" > $@
mincho1: mincho1/Makefile
	cd $@ && make
mincho3/Makefile: dump_newest_only.txt glyphs.txt
	mkdir -p mincho3
	./mkmkfile.rb mincho3.ttf 3 "HZ Mincho" "Book" "HZ 明朝" "標準" > $@
mincho3: mincho3/Makefile
	cd $@ && make
mincho5/Makefile: dump_newest_only.txt glyphs.txt
	mkdir -p mincho5
	./mkmkfile.rb mincho5.ttf 5 "HZ Mincho" "Demi" "HZ 明朝" "中太" > $@
mincho5: mincho5/Makefile
	cd $@ && make
mincho7/Makefile: dump_newest_only.txt glyphs.txt
	mkdir -p mincho7
	./mkmkfile.rb mincho7.ttf 7 "HZ Mincho" "Bold" "HZ 明朝" "太" > $@
mincho7: mincho7/Makefile
	cd $@ && make

clean:
	-rm -rf $(GENERATABLES)

distclean:
	-rm -rf $(TARGETS)
