SUBDIRS=mincho1 mincho3 mincho5 mincho7 mincho9 \
minchof1 minchof3 minchof5 minchof7 minchof9
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

glyphs.txt: groups/7bit-ascii.txt groups/jisx0208-non-kanji.txt \
groups/jisx0208-level-1.txt groups/jisx0208-level-2.txt \
groups/jisx0208-compatibility.txt \
groups/jisx0201-katakana.txt
	cat $^ | sort | uniq > $@

mincho1/Makefile: dump_newest_only.txt glyphs.txt
	mkdir -p mincho1
	./mkmkfile.rb mincho1.ttf 1 "HZ Mincho" "Light" "HZ 明朝" "細" /dev/null > $@
mincho1: mincho1/Makefile
	cd $@ && make
mincho3/Makefile: dump_newest_only.txt glyphs.txt
	mkdir -p mincho3
	./mkmkfile.rb mincho3.ttf 3 "HZ Mincho" "Book" "HZ 明朝" "標準" /dev/null > $@
mincho3: mincho3/Makefile
	cd $@ && make
mincho5/Makefile: dump_newest_only.txt glyphs.txt
	mkdir -p mincho5
	./mkmkfile.rb mincho5.ttf 5 "HZ Mincho" "Demi" "HZ 明朝" "中太" /dev/null > $@
mincho5: mincho5/Makefile
	cd $@ && make
mincho7/Makefile: dump_newest_only.txt glyphs.txt
	mkdir -p mincho7
	./mkmkfile.rb mincho7.ttf 7 "HZ Mincho" "Bold" "HZ 明朝" "太" /dev/null > $@
mincho7: mincho7/Makefile
	cd $@ && make
mincho9/Makefile: dump_newest_only.txt glyphs.txt
	mkdir -p mincho9
	./mkmkfile.rb mincho9.ttf 9 "HZ Mincho" "Extra" "HZ 明朝" "極太" /dev/null > $@
mincho9: mincho9/Makefile
	cd $@ && make

minchof1/Makefile: dump_newest_only.txt glyphs.txt fullwidth.sed
	mkdir -p minchof1
	./mkmkfile.rb minchof1.ttf 1 "HZ Mincho F" "Light" "HZ 明朝 F" "細" ../fullwidth.sed > $@
minchof1: minchof1/Makefile
	cd $@ && make
minchof3/Makefile: dump_newest_only.txt glyphs.txt fullwidth.sed
	mkdir -p minchof3
	./mkmkfile.rb minchof3.ttf 3 "HZ Mincho F" "Book" "HZ 明朝 F" "標準" ../fullwidth.sed > $@
minchof3: minchof3/Makefile
	cd $@ && make
minchof5/Makefile: dump_newest_only.txt glyphs.txt fullwidth.sed
	mkdir -p minchof5
	./mkmkfile.rb minchof5.ttf 5 "HZ Mincho F" "Demi" "HZ 明朝 F" "中太" ../fullwidth.sed > $@
minchof5: minchof5/Makefile
	cd $@ && make
minchof7/Makefile: dump_newest_only.txt glyphs.txt fullwidth.sed
	mkdir -p minchof7
	./mkmkfile.rb minchof7.ttf 7 "HZ Mincho F" "Bold" "HZ 明朝 F" "太" ../fullwidth.sed > $@
minchof7: minchof7/Makefile
	cd $@ && make
minchof9/Makefile: dump_newest_only.txt glyphs.txt fullwidth.sed
	mkdir -p minchof9
	./mkmkfile.rb minchof9.ttf 9 "HZ Mincho F" "Extra" "HZ 明朝 F" "極太" ../fullwidth.sed > $@
minchof9: minchof9/Makefile
	cd $@ && make

clean:
	-rm -rf $(GENERATABLES)

distclean:
	-rm -rf $(TARGETS)
