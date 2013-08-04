SUBDIRS=mincho1 mincho3 mincho5 mincho7 mincho9
DOWNLOADABLES=dump.tar.gz
GENERATABLES=dump_newest_only.txt fullwidth.sed glyphs.txt cidpua.map \
cidalias.txt cidalias.sed groups/cidalias.txt \
cidalias1.txt cidalias2.txt $(SUBDIRS)
TARGETS=$(GENERATABLES) $(DOWNLOADABLES)

.PHONY: all fetch clean distclean $(SUBDIRS)
all: $(TARGETS)

fetch: $(DOWNLOADABLES)

dump.tar.gz:
	wget -O $@ http://glyphwiki.org/dump.tar.gz

dump_newest_only.txt: dump.tar.gz
	tar xfz $< $@ && touch $@

fullwidth.sed: fullwidth.txt
	./fullwidth.pl < $< > $@

cidalias1.txt: pua-addenda.txt
	./cidpua.rb < $< > $@
cidalias2.txt: dump_newest_only.txt
	cat $^ | ./cidalias.rb > $@
cidalias.txt: cidalias1.txt cidalias2.txt
	cat $^ > $@

groups/cidalias.txt: cidalias.txt
	cat $^ | cut -f 1 > $@

cidalias.sed: cidalias.txt
	cat $^ | ./cidalias_sed.rb > $@

glyphs.txt: groups/cidalias.txt
	cat $^ | sort | uniq > $@

cidpua.map:
	./mkcfinfo.rb > $@

mincho1/Makefile: dump_newest_only.txt glyphs.txt cidalias.sed cidpua.map
	mkdir -p mincho1
	./mkmkfile.rb mincho1.ttf 1 "HZ Mincho" "Light" "HZ 明朝" "細" ../cidalias.sed > $@
mincho1: mincho1/Makefile
	cd $@ && make
mincho3/Makefile: dump_newest_only.txt glyphs.txt cidalias.sed cidpua.map
	mkdir -p mincho3
	./mkmkfile.rb mincho3.ttf 3 "HZ Mincho" "Book" "HZ 明朝" "標準" ../cidalias.sed > $@
mincho3: mincho3/Makefile
	cd $@ && make
mincho5/Makefile: dump_newest_only.txt glyphs.txt cidalias.sed cidpua.map
	mkdir -p mincho5
	./mkmkfile.rb mincho5.ttf 5 "HZ Mincho" "Demi" "HZ 明朝" "中太" ../cidalias.sed > $@
mincho5: mincho5/Makefile
	cd $@ && make
mincho7/Makefile: dump_newest_only.txt glyphs.txt cidalias.sed cidpua.map
	mkdir -p mincho7
	./mkmkfile.rb mincho7.ttf 7 "HZ Mincho" "Bold" "HZ 明朝" "太" ../cidalias.sed > $@
mincho7: mincho7/Makefile
	cd $@ && make
mincho9/Makefile: dump_newest_only.txt glyphs.txt cidalias.sed cidpua.map
	mkdir -p mincho9
	./mkmkfile.rb mincho9.ttf 9 "HZ Mincho" "Extra" "HZ 明朝" "極太" ../cidalias.sed > $@
mincho9: mincho9/Makefile
	cd $@ && make

clean:
	-rm -rf $(GENERATABLES)

distclean:
	-rm -rf $(TARGETS)
