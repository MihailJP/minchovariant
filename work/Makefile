TARGETS=head.txt parts.txt foot.txt engine makeglyph.js work.ttf

.PHONY: all clean font
all: $(TARGETS)

head.txt:
	echo "New()" > $@
	echo "Reencode(\"UnicodeFull\")" >> $@
	echo "ScaleToEm(4096)" >> $@
parts.txt:
	cat ../dump_newest_only.txt | ../mkparts.pl > $@
foot.txt:
	touch $@
engine:
	ln -s ../kage/engine $@
makeglyph.js:
	echo "load(\"engine/2d.js\");" > $@
	cat ../kage/makettf/makeglyph.js >> $@

work.ttf: head.txt parts.txt foot.txt engine makeglyph.js
	../kage/makettf/makettf.pl . work mincho 1

clean:
	-rm -rf $(TARGETS) work.scr work.log build
