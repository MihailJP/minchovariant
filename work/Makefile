TARGETS=head.txt parts.txt foot.txt engine makeglyph.js makettf.pl work.ttf

.PHONY: all clean font
all: $(TARGETS)

head.txt:
	echo "New()" > $@
	echo "Reencode(\"UnicodeFull\")" >> $@
parts.txt:
	cat ../dump_newest_only.txt | ../mkparts.pl > $@
foot.txt:
	touch $@
engine:
	ln -s ../kage/engine $@
makeglyph.js:
	echo "load(\"engine/2d.js\");" > $@
	cat ../kage/makettf/makeglyph.js >> $@
makettf.pl:
	cat ../kage/makettf/makettf.pl | sed -f ../makettf-patch.sed > $@
	chmod +x $@

work.ttf: head.txt parts.txt foot.txt engine makeglyph.js makettf.pl
	./makettf.pl . work mincho 1

clean:
	-rm -rf $(TARGETS) work.scr work.log build
