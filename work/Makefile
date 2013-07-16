TARGETS=head.txt parts.txt foot.txt engine makeglyph.js makettf.pl work.sfd work.ttf

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

work.sfd: head.txt parts.txt foot.txt engine makeglyph.js makettf.pl
	./makettf.pl . work mincho 1
work.ttf: work.sfd
	../merge-contours.py

clean:
	-rm -rf $(TARGETS) work.scr work.log build
