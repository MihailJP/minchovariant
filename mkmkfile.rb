#!/usr/bin/env ruby

AFD_DIR='/cygdrive/c/Apps/FDK'

(target, $weightNum, enName, enWeight, jaName, jaWeight, glyphFilter) = ARGV
license = 'Created by KAGE system. (http://fonts.jp/)'
psName = "#{enName} #{enWeight}".gsub(/\s/, "-")
cidmap = <<FINIS
../cidpua.map work.otf
../cidpua-blockelem.map ../mincho3/work.otf
../cidpua-dingbats.map ../mincho#{$weightNum.to_i > 7 ? 7 : ($weightNum.to_i > 3 ? $weightNum : 3)}/work.otf
../lgc.map lgc.otf
../lgc-fixed.map fixed.otf
../lgc-third.map third.otf
../lgc-quarter.map quarter.otf
../lgc-wide.map wide.otf
FINIS

def lgcFile(file, suffix)
	return <<FINIS
#{file}.otf: ../LGC/lgc#{$weightNum.to_i % 100}#{suffix}.otf
	cp $^ $@
../LGC/lgc#{$weightNum.to_i % 100}#{suffix}.otf:
	cd ../LGC && make lgc#{$weightNum.to_i % 100}#{suffix}.otf
FINIS
end

print <<FINIS
AFD_DIR=#{AFD_DIR}
AFD_BINDIR=$(AFD_DIR)/Tools/win
AFD_CMAPDIR=$(AFD_DIR)/Tools/SharedData/Adobe Cmaps/Adobe-Japan1
CMAP_HORIZONTAL="`cygpath -w "$(AFD_CMAPDIR)/UniJIS2004-UTF32-H"`"
CMAP_VERTICAL="`cygpath -w "$(AFD_CMAPDIR)/UniJIS2004-UTF32-V"`"
MERGEFONTS=$(AFD_BINDIR)/mergeFonts
MAKEOTF=cmd /c `cygpath -w $(AFD_BINDIR)/makeotf.cmd`

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
	./makettf.pl . work mincho #{$weightNum}
work2.sfd: work.sfd
	../merge-contours.py $< $@
work.otf: work2.sfd
	../width.py $< $@

#{lgcFile("lgc",      "")}
#{lgcFile("fixed",    "f")}
#{lgcFile("third",    "t")}
#{lgcFile("quarter",  "q")}
#{lgcFile("wide",     "w")}

#{target.sub(/\..+?$/, '.raw')}: work.otf cidfontinfo lgc.otf fixed.otf third.otf quarter.otf wide.otf
	$(MERGEFONTS) -cid cidfontinfo $@ #{cidmap.gsub(/\r?\n/, " ")}

#{target}: #{target.sub(/\..+?$/, '.raw')}
	$(MAKEOTF) -f $< -ff ../otf-features -mf ../fontMenuDB -o $@ -ch $(CMAP_HORIZONTAL) -cv $(CMAP_VERTICAL)
	stat #{target} > /dev/null

cidfontinfo:
	../makecfi.rb '#{enName}' '#{enWeight}' > $@

clean:
	-rm -rf $(TARGETS) work.scr work.log build
FINIS
