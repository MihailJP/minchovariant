#!/usr/bin/env ruby

AFD_DIR='/cygdrive/c/Apps/FDK'
AFD_BINDIR="#{AFD_DIR}/Tools/win"

(target, weightNum, enName, enWeight, jaName, jaWeight, glyphFilter) = ARGV
license = 'Created by KAGE system. (http://fonts.jp/)'
psName = "#{enName} #{enWeight}".gsub(/\s/, "-")
print <<FINIS
TARGETS=head.txt parts.txt foot.txt engine makeglyph.js makettf.pl \
work.sfd work2.sfd work.otf #{target.sub(/\..+?$/, '.raw')} cidfontinfo #{target}

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
	cat ../dump_newest_only.txt | ../mkparts.pl | sed -f #{glyphFilter} > $@
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
work.otf: work2.sfd
	../width.py $< $@

#{target.sub(/\..+?$/, '.raw')}: work.otf cidfontinfo
	$(AFD_BINDIR)/mergeFonts -cid cidfontinfo $@ ../cidpua.map work.otf

cidfontinfo:
	../makecfi.rb '#{enName}' '#{enWeight}' > $@

clean:
	-rm -rf $(TARGETS) work.scr work.log build
FINIS
