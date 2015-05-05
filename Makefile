SUBDIRS=mincho1 mincho3 mincho5 mincho7 mincho9
DOWNLOADABLES=dump.tar.gz
CIDMAPS=cidpua.map cidpua-kana.map cidpua-rkana.map \
cidpua-kumimoji.map cidpua-rot.map cidpua-ruby.map cidpua-kanap.map \
cidpua-kanavertp.map \
cidpua-symbols.map \
cidpua-blockelem.map cidpua-dingbats.map cidpua-enclosed.map
LGCMAPS=lgc.map lgc-fixed.map lgc-third.map lgc-quarter.map lgc-wide.map lgc-italic.map \
lgc-rotated.map lgc-rotfixed.map lgc-rotquarter.map lgc-rotthird.map lgc-rotitalic.map
METAMAKE_DEP_GENERATABLES=HZMincho.db dump_newest_only.txt dump_all_versions.txt glyphs.txt cidalias.sed \
otf-features parts.txt $(CIDMAPS) $(LGCMAPS) \
groups/HALFWIDTH.txt groups/NONSPACING.txt
METAMAKE_DEPS=$(METAMAKE_DEP_GENERATABLES) ./mkmkfile.rb
MAPGEN_DEPS=genmaps.rb HZMincho.db
GENERATABLES=$(METAMAKE_DEP_GENERATABLES) $(SUBDIRS) \
groups/cidalias.txt cidalias1.txt cidalias2.txt \
parts.txt \
ChangeLog
TARGETS=$(GENERATABLES) $(DOWNLOADABLES)
ARCHIVE_CONTENTS=README.md ChangeLog \
mincho1/mincho1.otf mincho3/mincho3.otf mincho5/mincho5.otf \
mincho7/mincho7.otf mincho9/mincho9.otf

.PHONY: all fetch clean distclean $(SUBDIRS) dist
all: $(TARGETS)

.DELETE_ON_ERROR: $(GENERATABLES) $(DOWNLOADABLES)

fetch: $(DOWNLOADABLES)

dump.tar.gz:
	wget -O $@ http://glyphwiki.org/dump.tar.gz

dump_newest_only.txt: dump.tar.gz
	tar xfz $< $@ && touch $@
dump_all_versions.txt: dump.tar.gz
	tar xfz $< $@ && touch $@

cidalias1.txt: pua-addenda.txt
	./cidpua.rb < $< > $@
cidalias2.txt: dump_newest_only.txt dump_all_versions.txt
	cat $^ | ./cidalias.rb > $@
cidalias.txt: cidalias1.txt cidalias2.txt pua-extension.txt
	cat $^ > $@

HZMincho.db: HZMincho.sql gensql.rb
	rm -f $@; cat $< | ./gensql.rb | sqlite3 $@

otf-features: HZMincho.db genfeat.rb
	./genfeat.rb > $@

cidpua.map: $(MAPGEN_DEPS)
	./genmaps.rb 0 > $@
cidpua-kana.map: $(MAPGEN_DEPS)
	./genmaps.rb 1 > $@
cidpua-rkana.map: $(MAPGEN_DEPS)
	./genmaps.rb 2 > $@
cidpua-kumimoji.map: $(MAPGEN_DEPS)
	./genmaps.rb 4 > $@
cidpua-rot.map: $(MAPGEN_DEPS)
	./genmaps.rb 5 > $@
cidpua-ruby.map: $(MAPGEN_DEPS)
	./genmaps.rb 6 > $@
cidpua-kanap.map: $(MAPGEN_DEPS)
	./genmaps.rb 7 > $@
cidpua-kanavertp.map: $(MAPGEN_DEPS)
	./genmaps.rb 9 > $@
cidpua-symbols.map: $(MAPGEN_DEPS)
	./genmaps.rb 10 > $@
cidpua-blockelem.map: $(MAPGEN_DEPS)
	./genmaps.rb 11 > $@
cidpua-dingbats.map: $(MAPGEN_DEPS)
	./genmaps.rb 12 > $@
cidpua-enclosed.map: $(MAPGEN_DEPS)
	./genmaps.rb 13 > $@
lgc.map: $(MAPGEN_DEPS)
	./genmaps.rb 30 > $@
lgc-fixed.map: $(MAPGEN_DEPS)
	./genmaps.rb 31 > $@
lgc-third.map: $(MAPGEN_DEPS)
	./genmaps.rb 32 > $@
lgc-quarter.map: $(MAPGEN_DEPS)
	./genmaps.rb 33 > $@
lgc-wide.map: $(MAPGEN_DEPS)
	./genmaps.rb 34 > $@
lgc-italic.map: $(MAPGEN_DEPS)
	./genmaps.rb 37 > $@
lgc-rotated.map: $(MAPGEN_DEPS)
	./genmaps.rb 50 > $@
lgc-rotfixed.map: $(MAPGEN_DEPS)
	./genmaps.rb 51 > $@
lgc-rotquarter.map: $(MAPGEN_DEPS)
	./genmaps.rb 52 > $@
lgc-rotthird.map: $(MAPGEN_DEPS)
	./genmaps.rb 53 > $@
lgc-rotitalic.map: $(MAPGEN_DEPS)
	./genmaps.rb 57 > $@

groups/cidalias.txt: cidalias.txt
	cd groups; $(MAKE) cidalias.txt
groups/HALFWIDTH.txt:
	cd groups; $(MAKE) HALFWIDTH.txt
groups/NONSPACING.txt:
	cd groups; $(MAKE) NONSPACING.txt

cidalias.sed: cidalias.txt
	cat $^ | ./cidalias_sed.rb > $@

glyphs.txt: groups/cidalias.txt
	cat $^ | sort | uniq > $@

LGC/Makefile: HZMincho.db LGC/metamake.rb
	cd LGC && (./metamake.rb > Makefile)

parts.txt: dump_newest_only.txt dump_all_versions.txt cidalias.sed
	cat dump_newest_only.txt dump_all_versions.txt | ./mkparts.pl | sed -f cidalias.sed | ./kage-roofed-l2rd.rb > $@

mincho1/Makefile: $(METAMAKE_DEPS)
	mkdir -p mincho1
	./mkmkfile.rb mincho1.otf 1 "HZ Mincho" "Light" "HZ 明朝" "細" > $@
mincho1: LGC/Makefile mincho1/Makefile mincho3/work.otf LGC/lgc1.otf
	cd $@ && $(MAKE)
LGC/lgc1.otf: LGC/Makefile
	cd LGC && $(MAKE) lgc1.otf

mincho3/Makefile: $(METAMAKE_DEPS)
	mkdir -p mincho3
	./mkmkfile.rb mincho3.otf 3 "HZ Mincho" "Book" "HZ 明朝" "標準" > $@
mincho3: LGC/Makefile mincho3/Makefile LGC/lgc3.otf
	cd $@ && $(MAKE)
mincho3/work.otf: mincho3
	cd mincho3 && $(MAKE) work.otf
LGC/lgc3.otf: LGC/Makefile
	cd LGC && $(MAKE) lgc3.otf

mincho5/Makefile: $(METAMAKE_DEPS)
	mkdir -p mincho5
	./mkmkfile.rb mincho5.otf 105 "HZ Mincho" "Demi" "HZ 明朝" "中太" > $@
mincho5: LGC/Makefile mincho5/Makefile mincho3/work.otf LGC/lgc5.otf
	cd $@ && $(MAKE)
LGC/lgc5.otf: LGC/Makefile
	cd LGC && $(MAKE) lgc5.otf

mincho7/Makefile: $(METAMAKE_DEPS)
	mkdir -p mincho7
	./mkmkfile.rb mincho7.otf 107 "HZ Mincho" "Bold" "HZ 明朝" "太" > $@
mincho7: LGC/Makefile mincho7/Makefile mincho3/work.otf LGC/lgc7.otf
	cd $@ && $(MAKE)
LGC/lgc7.otf: LGC/Makefile
	cd LGC && $(MAKE) lgc7.otf

mincho9/Makefile: $(METAMAKE_DEPS)
	mkdir -p mincho9
	./mkmkfile.rb mincho9.otf 109 "HZ Mincho" "Heavy" "HZ 明朝" "極太" > $@
mincho9: LGC/Makefile mincho9/Makefile mincho3/work.otf LGC/lgc9.otf
	cd $@ && $(MAKE)
LGC/lgc9.otf: LGC/Makefile
	cd LGC && $(MAKE) lgc9.otf

mincho1/mincho1.otf: mincho1
mincho3/mincho3.otf: mincho3
mincho5/mincho5.otf: mincho5
mincho7/mincho7.otf: mincho7
mincho9/mincho9.otf: mincho9

ChangeLog: .git
	./mkchglog.rb > $@

HZMincho.zip: $(ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZMincho; cp $^ HZMincho
	zip -m9r $@ HZMincho

HZMincho.tar.gz: $(ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZMincho; cp $^ HZMincho
	tar cfvz $@ HZMincho

HZMincho.tar.bz2: $(ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZMincho; cp $^ HZMincho
	tar cfvj $@ HZMincho

HZMincho.tar.xz: $(ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZMincho; cp $^ HZMincho
	tar cfvJ $@ HZMincho

dist: HZMincho.tar.xz

clean:
	-cd LGC && $(MAKE) clean
	-cd groups && $(MAKE) clean
	-rm -rf $(GENERATABLES)
	-rm -rf HZMincho
	-rm -rf intersect*.pe
	-rm -rf *.pyc

distclean: clean
	-rm -rf $(TARGETS)
	-cd groups && $(MAKE) distclean
