SUBDIRS=mincho1 mincho3 mincho5 mincho7 mincho9 \
socho1 socho3 socho5 socho7 \
gothic1 gothic3 gothic5 gothic7 \
latin1 latin3 latin5 latin7
DOWNLOADABLES=dump.tar.gz
CIDMAPS=cidpua.map cidpua-kana.map cidpua-rkana.map \
cidpua-kumimoji.map cidpua-rot.map cidpua-ruby.map cidpua-kanap.map \
cidpua-kanavertp.map cidpua-symbols.map cidpua-enclalnum.map cidpua-enclosed.map \
cidpua-uprightsym.map cidpua-uprightruby.map
LGCMAPS=lgc.map lgc-fixed.map lgc-third.map lgc-quarter.map lgc-wide.map lgc-italic.map \
lgc-rotated.map lgc-rotfixed.map lgc-rotquarter.map lgc-rotthird.map lgc-rotitalic.map
METAMAKE_DEP_GENERATABLES=HZMincho.db dump_newest_only.txt dump_all_versions.txt glyphs.txt cidalias.sed \
otf-features otf-features-socho otf-features-gothic otf-features-latin \
parts.txt parts-socho.txt parts-gothic.txt parts-latin.txt $(CIDMAPS) $(LGCMAPS) \
groups/HALFWIDTH.txt groups/NONSPACING.txt
METAMAKE_DEPS=$(METAMAKE_DEP_GENERATABLES) ./mkmkfile.rb
MAPGEN_DEPS=genmaps.rb HZMincho.db
GENERATABLES=$(METAMAKE_DEP_GENERATABLES) \
groups/cidalias.txt cidalias.txt cidalias1.txt cidalias2.txt \
parts.dat parts-socho.dat parts-gothic.dat parts-latin.dat \
parts.txt parts-socho.txt parts-gothic.txt parts-latin.txt \
ChangeLog README-Socho.md README-Gothic.md README-Latin.md
TARGETS=$(SUBDIRS)
ARCHIVE_CONTENTS=README.md ChangeLog \
mincho1/mincho1.otf mincho3/mincho3.otf mincho5/mincho5.otf \
mincho7/mincho7.otf mincho9/mincho9.otf
SOCHO_ARCHIVE_CONTENTS=README-Socho.md ChangeLog \
socho1/socho1.otf socho3/socho3.otf socho5/socho5.otf \
socho7/socho7.otf
GOTHIC_ARCHIVE_CONTENTS=README-Gothic.md ChangeLog \
gothic1/gothic1.otf gothic3/gothic3.otf gothic5/gothic5.otf \
gothic7/gothic7.otf
LATIN_ARCHIVE_CONTENTS=README-Latin.md ChangeLog \
latin1/latin1.otf latin3/latin3.otf latin5/latin5.otf \
latin7/latin7.otf

.PHONY: all fetch clean distclean mostlyclean $(SUBDIRS) dist
all: $(TARGETS)

.DELETE_ON_ERROR: $(GENERATABLES) $(DOWNLOADABLES)

fetch: $(DOWNLOADABLES)

dump.tar.gz:
	wget --no-check-certificate -O $@ https://glyphwiki.org/dump.tar.gz

dump_newest_only.txt: dump.tar.gz
	tar xfz $< $@ && touch $@
dump_all_versions.txt: dump.tar.gz
	tar xfz $< $@ && touch $@

.INTERMEDIATE: cidalias1.txt cidalias2.txt
cidalias1.txt: pua-addenda.txt
	./cidpua.rb < $< > $@
cidalias2.txt: dump_newest_only.txt dump_all_versions.txt
	cat $^ | ./cidalias.rb > $@
cidalias.txt: cidalias1.txt cidalias2.txt pua-extension.txt
	cat $^ > $@

HZMincho.db: HZMincho.sql gensql.rb
	rm -f $@; cat $< | ./gensql.rb | sqlite3 $@

otf-features: HZMincho.db genfeat.rb credits.rb
	./genfeat.rb mincho > $@
otf-features-socho: HZMincho.db genfeat.rb credits.rb
	./genfeat.rb socho > $@
otf-features-gothic: HZMincho.db genfeat.rb credits.rb
	./genfeat.rb gothic > $@
otf-features-latin: HZMincho.db genfeat.rb credits.rb
	./genfeat.rb latin > $@

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
cidpua-enclalnum.map: $(MAPGEN_DEPS)
	./genmaps.rb 12 > $@
cidpua-enclosed.map: $(MAPGEN_DEPS)
	./genmaps.rb 13 > $@
cidpua-uprightsym.map: $(MAPGEN_DEPS)
	./genmaps.rb 14 > $@
cidpua-uprightruby.map: $(MAPGEN_DEPS)
	./genmaps.rb 19 > $@
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

cidalias.sed: cidalias.txt HZMincho.db
	cat $< | ./cidalias_sed.rb > $@

glyphs.txt: groups/cidalias.txt HZMincho.db
	cat $< | sort | uniq | ./cidalias_filter.rb > $@

LGC/Makefile: HZMincho.db LGC/metamake.rb
	cd LGC && (./metamake.rb > Makefile)
FS-LGC/Makefile: HZMincho.db FS-LGC/metamake.rb
	cd FS-LGC && (./metamake.rb > Makefile)
Goth-LGC/Makefile: HZMincho.db Goth-LGC/metamake.rb
	cd Goth-LGC && (./metamake.rb > Makefile)
Lat-LGC/Makefile: HZMincho.db Lat-LGC/metamake.rb
	cd Lat-LGC && (./metamake.rb > Makefile)

.INTERMEDIATE: parts.dat parts-socho.dat parts-gothic.dat parts-latin.dat
parts.dat: dump_newest_only.txt dump_all_versions.txt
	cat $^ | ./mkparts.pl | ./kage-roofed-l2rd.rb > $@
parts-socho.dat: parts.dat socho.csv
	cat $< | ./replace-glyph.rb -i -l socho.csv | sed -f aj1-de-j.sed | ./kage-socho.rb > $@
parts-gothic.dat: parts.dat gothic.csv
	cat $< | ./replace-glyph.rb -i -l gothic.csv > $@
parts-latin.dat: parts.dat latin.csv
	cat $< | ./replace-glyph.rb -i -l latin.csv > $@
parts.txt: parts.dat cidalias.sed
	cat $< | sed -f cidalias.sed > $@
parts-socho.txt: parts-socho.dat cidalias.sed
	cat $< | sed -f cidalias.sed > $@
parts-gothic.txt: parts-gothic.dat cidalias.sed
	cat $< | sed -f cidalias.sed > $@
parts-latin.txt: parts-latin.dat cidalias.sed
	cat $< | sed -f cidalias.sed > $@

mincho1/Makefile: $(METAMAKE_DEPS)
	mkdir -p mincho1
	./mkmkfile.rb mincho1.otf mincho 1 "HZ Mincho Pr6N" "Light" "HZ 明朝 Pr6N" "細" > $@
mincho1: LGC/Makefile mincho1/Makefile mincho3/work.otf LGC/lgc1.otf
	cd $@ && $(MAKE)
LGC/lgc1.otf: LGC/Makefile
	cd LGC && $(MAKE) lgc1.otf

mincho3/Makefile: $(METAMAKE_DEPS)
	mkdir -p mincho3
	./mkmkfile.rb mincho3.otf mincho 3 "HZ Mincho Pr6N" "Book" "HZ 明朝 Pr6N" "標準" > $@
mincho3: LGC/Makefile mincho3/Makefile LGC/lgc3.otf
	cd $@ && $(MAKE)
mincho3/work.otf: mincho3
	cd mincho3 && $(MAKE) work.otf
LGC/lgc3.otf: LGC/Makefile
	cd LGC && $(MAKE) lgc3.otf

mincho5/Makefile: $(METAMAKE_DEPS)
	mkdir -p mincho5
	./mkmkfile.rb mincho5.otf mincho 105 "HZ Mincho Pr6N" "Demi" "HZ 明朝 Pr6N" "中太" > $@
mincho5: LGC/Makefile mincho5/Makefile mincho3/work.otf LGC/lgc5.otf
	cd $@ && $(MAKE)
LGC/lgc5.otf: LGC/Makefile
	cd LGC && $(MAKE) lgc5.otf

mincho7/Makefile: $(METAMAKE_DEPS)
	mkdir -p mincho7
	./mkmkfile.rb mincho7.otf mincho 107 "HZ Mincho Pr6N" "Bold" "HZ 明朝 Pr6N" "太" > $@
mincho7: LGC/Makefile mincho7/Makefile mincho3/work.otf LGC/lgc7.otf
	cd $@ && $(MAKE)
LGC/lgc7.otf: LGC/Makefile
	cd LGC && $(MAKE) lgc7.otf

mincho9/Makefile: $(METAMAKE_DEPS)
	mkdir -p mincho9
	./mkmkfile.rb mincho9.otf mincho 109 "HZ Mincho Pr6N" "Heavy" "HZ 明朝 Pr6N" "極太" > $@
mincho9: LGC/Makefile mincho9/Makefile mincho3/work.otf LGC/lgc9.otf
	cd $@ && $(MAKE)
LGC/lgc9.otf: LGC/Makefile
	cd LGC && $(MAKE) lgc9.otf

socho1/Makefile: $(METAMAKE_DEPS)
	mkdir -p socho1
	./mkmkfile.rb socho1.otf socho 201 "HZ Socho Pr6N" "Light" "HZ 宋朝 Pr6N" "細" > $@
socho1: FS-LGC/Makefile socho1/Makefile socho3/work.otf FS-LGC/lgc1.otf mincho3/work.otf mincho1/work.otf
	cd $@ && $(MAKE)
FS-LGC/lgc1.otf: FS-LGC/Makefile
	cd FS-LGC && $(MAKE) lgc1.otf

socho3/Makefile: $(METAMAKE_DEPS)
	mkdir -p socho3
	./mkmkfile.rb socho3.otf socho 203 "HZ Socho Pr6N" "Book" "HZ 宋朝 Pr6N" "標準" > $@
socho3: FS-LGC/Makefile socho3/Makefile FS-LGC/lgc3.otf mincho3/work.otf
	cd $@ && $(MAKE)
socho3/work.otf: socho3
	cd socho3 && $(MAKE) work.otf
FS-LGC/lgc3.otf: FS-LGC/Makefile
	cd FS-LGC && $(MAKE) lgc3.otf

socho5/Makefile: $(METAMAKE_DEPS)
	mkdir -p socho5
	./mkmkfile.rb socho5.otf socho 205 "HZ Socho Pr6N" "Demi" "HZ 宋朝 Pr6N" "中太" > $@
socho5: FS-LGC/Makefile socho5/Makefile socho3/work.otf FS-LGC/lgc5.otf mincho3/work.otf mincho5/work.otf
	cd $@ && $(MAKE)
FS-LGC/lgc5.otf: FS-LGC/Makefile
	cd FS-LGC && $(MAKE) lgc5.otf

socho7/Makefile: $(METAMAKE_DEPS)
	mkdir -p socho7
	./mkmkfile.rb socho7.otf socho 207 "HZ Socho Pr6N" "Bold" "HZ 宋朝 Pr6N" "太" > $@
socho7: FS-LGC/Makefile socho7/Makefile socho3/work.otf FS-LGC/lgc7.otf mincho3/work.otf mincho7/work.otf
	cd $@ && $(MAKE)
FS-LGC/lgc7.otf: FS-LGC/Makefile
	cd FS-LGC && $(MAKE) lgc7.otf

gothic1/Makefile: $(METAMAKE_DEPS)
	mkdir -p gothic1
	./mkmkfile.rb gothic1.otf gothic 1 "HZ Gothic Pr6N" "Light" "HZ ゴシック Pr6N" "細" > $@
gothic1: Goth-LGC/Makefile gothic1/Makefile gothic3/work.otf Goth-LGC/lgc1.otf mincho3/work.otf mincho1/work.otf
	cd $@ && $(MAKE)
Goth-LGC/lgc1.otf: Goth-LGC/Makefile
	cd Goth-LGC && $(MAKE) lgc1.otf

gothic3/Makefile: $(METAMAKE_DEPS)
	mkdir -p gothic3
	./mkmkfile.rb gothic3.otf gothic 3 "HZ Gothic Pr6N" "Book" "HZ ゴシック Pr6N" "標準" > $@
gothic3: Goth-LGC/Makefile gothic3/Makefile Goth-LGC/lgc3.otf
	cd $@ && $(MAKE)
gothic3/work.otf: gothic3
	cd gothic3 && $(MAKE) work.otf
Goth-LGC/lgc3.otf: Goth-LGC/Makefile
	cd Goth-LGC && $(MAKE) lgc3.otf

gothic5/Makefile: $(METAMAKE_DEPS)
	mkdir -p gothic5
	./mkmkfile.rb gothic5.otf gothic 5 "HZ Gothic Pr6N" "Demi" "HZ ゴシック Pr6N" "中太" > $@
gothic5: Goth-LGC/Makefile gothic5/Makefile gothic3/work.otf Goth-LGC/lgc5.otf mincho3/work.otf mincho5/work.otf
	cd $@ && $(MAKE)
Goth-LGC/lgc5.otf: Goth-LGC/Makefile
	cd Goth-LGC && $(MAKE) lgc5.otf

gothic7/Makefile: $(METAMAKE_DEPS)
	mkdir -p gothic7
	./mkmkfile.rb gothic7.otf gothic 7 "HZ Gothic Pr6N" "Bold" "HZ ゴシック Pr6N" "太" > $@
gothic7: Goth-LGC/Makefile gothic7/Makefile gothic3/work.otf Goth-LGC/lgc7.otf mincho3/work.otf mincho7/work.otf
	cd $@ && $(MAKE)
Goth-LGC/lgc7.otf: Goth-LGC/Makefile
	cd Goth-LGC && $(MAKE) lgc7.otf

latin1/Makefile: $(METAMAKE_DEPS)
	mkdir -p latin1
	./mkmkfile.rb latin1.otf latin 1 "HZ Latin Pr6N" "Light" "HZ ラテン Pr6N" "細" > $@
latin1: Lat-LGC/Makefile latin1/Makefile latin3/work.otf Lat-LGC/lgc1.otf mincho3/work.otf mincho1/work.otf
	cd $@ && $(MAKE)
Lat-LGC/lgc1.otf: Lat-LGC/Makefile
	cd Lat-LGC && $(MAKE) lgc1.otf

latin3/Makefile: $(METAMAKE_DEPS)
	mkdir -p latin3
	./mkmkfile.rb latin3.otf latin 3 "HZ Latin Pr6N" "Book" "HZ ラテン Pr6N" "標準" > $@
latin3: Lat-LGC/Makefile latin3/Makefile Lat-LGC/lgc3.otf
	cd $@ && $(MAKE)
latin3/work.otf: latin3
	cd latin3 && $(MAKE) work.otf
Lat-LGC/lgc3.otf: Lat-LGC/Makefile
	cd Lat-LGC && $(MAKE) lgc3.otf

latin5/Makefile: $(METAMAKE_DEPS)
	mkdir -p latin5
	./mkmkfile.rb latin5.otf latin 5 "HZ Latin Pr6N" "Demi" "HZ ラテン Pr6N" "中太" > $@
latin5: Lat-LGC/Makefile latin5/Makefile latin3/work.otf Lat-LGC/lgc5.otf mincho3/work.otf mincho5/work.otf
	cd $@ && $(MAKE)
Lat-LGC/lgc5.otf: Lat-LGC/Makefile
	cd Lat-LGC && $(MAKE) lgc5.otf

latin7/Makefile: $(METAMAKE_DEPS)
	mkdir -p latin7
	./mkmkfile.rb latin7.otf latin 7 "HZ Latin Pr6N" "Bold" "HZ ラテン Pr6N" "太" > $@
latin7: Lat-LGC/Makefile latin7/Makefile latin3/work.otf Lat-LGC/lgc7.otf mincho3/work.otf mincho7/work.otf
	cd $@ && $(MAKE)
Lat-LGC/lgc7.otf: Lat-LGC/Makefile
	cd Lat-LGC && $(MAKE) lgc7.otf


mincho1/work.otf: mincho1
mincho3/work.otf: mincho3
mincho5/work.otf: mincho5
mincho7/work.otf: mincho7
mincho9/work.otf: mincho9

socho1/work.otf: socho1
socho3/work.otf: socho3
socho5/work.otf: socho5
socho7/work.otf: socho7

gothic1/work.otf: gothic1
gothic3/work.otf: gothic3
gothic5/work.otf: gothic5
gothic7/work.otf: gothic7

latin1/work.otf: latin1
latin3/work.otf: latin3
latin5/work.otf: latin5
latin7/work.otf: latin7

mincho1/mincho1.otf: mincho1
mincho3/mincho3.otf: mincho3
mincho5/mincho5.otf: mincho5
mincho7/mincho7.otf: mincho7
mincho9/mincho9.otf: mincho9

socho1/socho1.otf: socho1
socho3/socho3.otf: socho3
socho5/socho5.otf: socho5
socho7/socho7.otf: socho7

gothic1/gothic1.otf: gothic1
gothic3/gothic3.otf: gothic3
gothic5/gothic5.otf: gothic5
gothic7/gothic7.otf: gothic7

latin1/latin1.otf: latin1
latin3/latin3.otf: latin3
latin5/latin5.otf: latin5
latin7/latin7.otf: latin7

ChangeLog: .git
	./mkchglog.rb > $@
README-Socho.md: README.md readme-socho.diff
	patch -o $@ -r /dev/null $^ && touch $@
README-Gothic.md: README.md readme-gothic.diff
	patch -o $@ -r /dev/null $^ && touch $@
README-Latin.md: README.md readme-latin.diff
	patch -o $@ -r /dev/null $^ && touch $@

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

HZSocho.zip: $(SOCHO_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZSocho; cp $^ HZSocho; mv HZSocho/README-Socho.md HZSocho/README.md
	zip -m9r $@ HZSocho
HZSocho.tar.gz: $(SOCHO_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZSocho; cp $^ HZSocho; mv HZSocho/README-Socho.md HZSocho/README.md
	tar cfvz $@ HZSocho
HZSocho.tar.bz2: $(SOCHO_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZSocho; cp $^ HZSocho; mv HZSocho/README-Socho.md HZSocho/README.md
	tar cfvj $@ HZSocho
HZSocho.tar.xz: $(SOCHO_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZSocho; cp $^ HZSocho; mv HZSocho/README-Socho.md HZSocho/README.md
	tar cfvJ $@ HZSocho

HZGothic.zip: $(GOTHIC_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZGothic; cp $^ HZGothic; mv HZGothic/README-Gothic.md HZGothic/README.md
	zip -m9r $@ HZGothic
HZGothic.tar.gz: $(GOTHIC_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZGothic; cp $^ HZGothic; mv HZGothic/README-Gothic.md HZGothic/README.md
	tar cfvz $@ HZGothic
HZGothic.tar.bz2: $(GOTHIC_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZGothic; cp $^ HZGothic; mv HZGothic/README-Gothic.md HZGothic/README.md
	tar cfvj $@ HZGothic
HZGothic.tar.xz: $(GOTHIC_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZGothic; cp $^ HZGothic; mv HZGothic/README-Gothic.md HZGothic/README.md
	tar cfvJ $@ HZGothic

HZLatin.zip: $(LATIN_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZLatin; cp $^ HZLatin; mv HZLatin/README-Latin.md HZLatin/README.md
	zip -m9r $@ HZLatin
HZLatin.tar.gz: $(LATIN_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZLatin; cp $^ HZLatin; mv HZLatin/README-Latin.md HZLatin/README.md
	tar cfvz $@ HZLatin
HZLatin.tar.bz2: $(LATIN_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZLatin; cp $^ HZLatin; mv HZLatin/README-Latin.md HZLatin/README.md
	tar cfvj $@ HZLatin
HZLatin.tar.xz: $(LATIN_ARCHIVE_CONTENTS)
	rm -f $@; mkdir -p HZLatin; cp $^ HZLatin; mv HZLatin/README-Latin.md HZLatin/README.md
	tar cfvJ $@ HZLatin

dist: HZMincho.tar.xz HZSocho.tar.xz HZGothic.tar.xz HZLatin.tar.xz

mostlyclean:
	-cd LGC && $(MAKE) clean
	-cd FS-LGC && $(MAKE) clean
	-cd Goth-LGC && $(MAKE) clean
	-cd Latin-LGC && $(MAKE) clean
	-cd groups && $(MAKE) clean
	-rm -rf $(GENERATABLES)
	-for i in $(SUBDIRS); do $(MAKE) -C $$i mostlyclean; done
	-rm -rf HZMincho HZSocho HZGothic HZLatin
	-rm -rf intersect*.pe
	-rm -rf *.pyc

clean:
	-rm -rf $(SUBDIRS)
	-rm -f parts.dat parts-socho.dat parts-gothic.dat parts-latin.dat

distclean: clean
	-rm -rf $(DOWNLOADABLES)
	-rm -rf dump_newest_only.txt dump_all_versions.txt
	-cd groups && $(MAKE) distclean
