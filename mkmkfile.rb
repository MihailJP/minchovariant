#!/usr/bin/env ruby

(target, weightNum, enName, enWeight, jaName, jaWeight) = ARGV
license = 'Created by KAGE system. (http://fonts.jp/)'
psName = "#{enName} #{enWeight}".gsub(/\s/, "-")
print <<FINIS
TARGETS=head.txt parts.txt foot.txt engine makeglyph.js makettf.pl work.sfd work2.sfd #{target}

.PHONY: all clean font
all: $(TARGETS)

head.txt:
	echo 'New()' > $@
	echo 'Reencode(\"UnicodeFull\")' >> $@
	echo 'SetFontNames(\"#{psName}\", \"#{enName}\", \"#{enName} #{enWeight}\", \"#{enWeight}\", \"#{license}\")' >> $@
	echo 'SetTTFName(0x409,0,\"#{license}\")' >> $@
	echo 'SetTTFName(0x409,1,\"#{enName}\")' >> $@
	echo 'SetTTFName(0x409,2,\"#{enWeight}\")' >> $@
	echo 'SetTTFName(0x409,4,\"#{enName} #{enWeight}\")' >> $@
	echo 'SetTTFName(0x411,1,\"#{jaName}\")' >> $@
	echo 'SetTTFName(0x411,2,\"#{jaWeight}\")' >> $@
	echo 'SetTTFName(0x411,4,\"#{jaName} #{jaWeight}\")' >> $@
parts.txt:
	cat ../dump_newest_only.txt | ../mkparts.pl > $@
foot.txt:
	touch $@
engine:
	ln -s ../kage/engine $@
makeglyph.js:
	echo 'load(\"engine/2d.js\");' > $@
	cat ../kage/makettf/makeglyph.js | sed -f ../makeglyph-patch.sed >> $@
makettf.pl:
	cat ../kage/makettf/makettf.pl | sed -f ../makettf-patch.sed > $@
	chmod +x $@

work.sfd: head.txt parts.txt foot.txt engine makeglyph.js makettf.pl
	./makettf.pl . work mincho #{weightNum}
work2.sfd: work.sfd
	../merge-contours.py $< $@
#{target}: work2.sfd
	../width.py $< $@

clean:
	-rm -rf $(TARGETS) work.scr work.log build
FINIS
