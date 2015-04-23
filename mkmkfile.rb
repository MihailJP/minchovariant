#!/usr/bin/env ruby

AFD_DIR='/cygdrive/c/Apps/FDK' # Needed for Cygwin, otherwise meaningless
require 'sqlite3'
DBFileName = 'HZMincho.db'
if not File.exist?(DBFileName) then raise IOError, "Database '#{DBFileName}' not found" end
fontDB = SQLite3::Database.new(DBFileName)

(target, $font, $weightNum, enName, enWeight, jaName, jaWeight, glyphFilter) = ARGV
license = 'Created by KAGE system. (http://fonts.jp/) / Alphabet glyphs by Andrey V. Panov (C) 2005 All rights reserved. / A few symbol glyphs are from George Doulos\\\' Symbola font. / AJ1-6 sans-serif glyphs from M+ fonts.'
psName = "#{enName} #{enWeight}".gsub(/\s/, "-")
cidmap = ""
fontDB.execute("SELECT mapFile, fontFile FROM subFont") {|subFont|
	cidmap += "../#{subFont[0]} #{eval("\"#{subFont[1]}\"")}\n"
}

$LGCdir = ($font == "socho" ? "FS-LGC" : "LGC")
$KanaDir = ($font == "socho" ? "FS-Kana" : "Kana")

def lgcFile(file, suffix)
	return <<FINIS
#{file}: ../#{$LGCdir}/lgc#{$weightNum.to_i % 100}#{suffix}.otf
	cp $^ $@
../#{$LGCdir}/lgc#{$weightNum.to_i % 100}#{suffix}.otf:
	cd ../#{$LGCdir} && $(MAKE) lgc#{$weightNum.to_i % 100}#{suffix}.otf
FINIS
end

def lgcFiles(db)
	result = ""
	db.execute("SELECT fontFile, procBaseFont, tSuffix FROM subFont JOIN lgcFont ON lgcFontTag = fontTag WHERE lgcFontTag IS NOT NULL") {|subFont|
		result += lgcFile((subFont[1] or subFont[0]), subFont[2])
	}
	return result
end

def iscygwin
	!!(RUBY_PLATFORM.downcase =~ /cygwin/)
end

def cygPath(path)
	if iscygwin then
		return "\"`cygpath -w \"#{path}\"`\""
	else
		return "\"#{path}\""
	end
end

def heavyFont?
	($font != "socho") and ($weightNum.to_i % 100 == 9)
end

print <<FINIS
AFD_DIR=#{iscygwin ? AFD_DIR : "#{ENV["HOME"]}/bin/FDK"}
AFD_BINDIR=$(AFD_DIR)/Tools/#{iscygwin ? 'win' : 'linux'}
AFD_CMAPDIR=$(AFD_DIR)/Tools/SharedData/Adobe Cmaps/Adobe-Japan1
CMAP_HORIZONTAL=#{cygPath "$(AFD_CMAPDIR)/UniJIS2004-UTF32-H"}
CMAP_VERTICAL=#{cygPath "$(AFD_CMAPDIR)/UniJIS2004-UTF32-V"}
MERGEFONTS=$(AFD_BINDIR)/mergeFonts
MAKEOTF=#{iscygwin ? 'cmd /c ' : ''}#{cygPath "$(AFD_BINDIR)/makeotf#{iscygwin ? '.cmd' : ''}"}

TARGETS=#{heavyFont? ? "ratio.txt " : ""}head.txt parts.txt foot.txt engine makeglyph.js kagecd.js makettf.pl \
#{target.sub(/\..+?$/, '.raw')} cidfontinfo #{iscygwin ? "" : "tmpcid.otf tmpcid.ttx " + target.sub(/\..+?$/, '.ttx')} #{target}

.PHONY: all clean font
all: $(TARGETS)

Makefile: ../dump_all_versions.txt ../glyphs.txt ../cidalias.sed ../HZMincho.sql ../mkmkfile.rb
	env MYDIR=$$(basename $$PWD) bash -c 'cd .. && $(MAKE) $$MYDIR/Makefile'

head.txt:
	echo 'New()' > $@
	echo 'Reencode(\"UnicodeFull\")' >> $@
	echo $$'SetFontNames(\"#{psName}\", \"#{enName}\", \"#{enName} #{enWeight}\", \"#{enWeight}\", \"#{license}\")' >> $@
	echo $$'SetTTFName(0x409,0,\"#{license}\")' >> $@
	echo 'SetTTFName(0x409,1,\"#{enName}\")' >> $@
	echo 'SetTTFName(0x409,2,\"#{enWeight}\")' >> $@
	echo 'SetTTFName(0x409,4,\"#{enName} #{enWeight}\")' >> $@
	echo 'SetTTFName(0x411,1,\"#{jaName}\")' >> $@
	echo 'SetTTFName(0x411,2,\"#{jaWeight}\")' >> $@
	echo 'SetTTFName(0x411,4,\"#{jaName} #{jaWeight}\")' >> $@
#{heavyFont? ? <<SUBRECIPE
ratio.txt:
	cat ../dump_newest_only.txt ../dump_all_versions.txt | ../mkparts.pl | sed -f #{glyphFilter} | ../cntstroke.rb > $@
SUBRECIPE
: ""}parts.txt:#{heavyFont? ? " ratio.txt" : ""}
	cat ../dump_newest_only.txt ../dump_all_versions.txt | ../mkparts.pl | sed -f #{glyphFilter} | ../kage-roofed-l2rd.rb #{heavyFont? ? "| ../kage-width.rb -f $< " : ""}#{$font == "socho" ? "| ../kage-socho.rb " : ""}> $@
foot.txt:
	touch $@
engine:
	ln -s ../kage/engine $@
makeglyph.js:
	cat ../kage/makettf/makeglyph.js | sed -f ../makeglyph-patch.sed > $@
kage.js:
	cat ../kage/engine/kage.js | sed -f ../kage-patch.sed > $@
kagecd.js:
	perl ../kagecd-patch.pl ../kage/engine/kagecd.js | sed -f ../kagecd-fudeosae.sed > $@
kagedf.js:
	cat ../kage/engine/kagedf.js | sed -f ../kagedf-patch.sed > $@
makettf.pl:
	cat ../kage/makettf/makettf.pl | sed -f ../makettf-patch.sed > $@
	chmod +x $@

work_.sfd: head.txt parts.txt foot.txt engine makeglyph.js kage.js kagecd.js kagedf.js makettf.pl
	./makettf.pl . work_ #{$font} #{$weightNum}
work.sfd: work_.sfd
	../fixup-layers.py $< $@
#{$font == "socho" ? <<SOCHO
work2_.sfd: work.sfd
	../socho.py 1 $< $@
SOCHO
: <<MINCHO
work2_.sfd: work.sfd#{heavyFont? ? " ratio.txt" : ""}
	../fix-contour-width.py #{heavyFont? ? "ratio.txt" : "1.0"} $< $@
MINCHO
}work2.sfd: work2_.sfd
	../fixup-layers.py $< $@
temp.otf: work2.sfd
	../width.py $< $@
work.otf: temp.otf
	fontforge -lang=ff -c 'Open("$<"); Generate("$@")'

kana_.sfd: ../#{$KanaDir}/Kana.sfdir ../#{$KanaDir}/Kana-Bold.sfdir
	../kana.py #{$weightNum} $^ $@
kana.sfd: kana_.sfd
	../fixup-layers.py $< $@
kana2_.sfd: kana.sfd
	../smooth-contours.py $< $@
kana2.sfd: kana2_.sfd
	../fixup-layers.py $< $@
kana.otf: kana2.sfd
	../width.py $< $@

rotcjk.sfd: work.otf
	../#{$LGCdir}/rotate.py $< $@
rotcjk.otf: rotcjk.sfd
	../rotcid.py 5 $< $@

rotkana.sfd: kana.otf
	../#{$LGCdir}/rotate.py $< $@
rotkana.otf: rotkana.sfd
	../rotcid.py 2 $< $@

#{lgcFiles(fontDB)}

enclosed.otf: enclosed-base.otf kana.otf work.otf
	../enclose.py $^ $@
ruby.otf: ruby-base.otf kana.otf work.otf
	../enclose.py $^ $@
kanap.otf: kanap-base.otf kana.otf work.otf
	../proportional.py $^ $@
kanavp.otf: kanavp-base.otf kana.otf work.otf
	../proportional-vert.py $^ $@

#{$font == "socho" ? <<SOCHO
upright_.sfd: work.sfd
	../socho.py 0 $< $@
upright.sfd: upright_.sfd
	../fixup-layers.py $< $@
upright_.otf: upright.sfd
	../width.py $< $@
upright.otf: upright_.otf
	fontforge -lang=ff -c 'Open("$<"); Generate("$@")'
SOCHO
: <<MINCHO
upright.otf: work.otf
	ln -s $< $@
MINCHO
}
#{target.sub(/\..+?$/, '.raw')}: work.otf cidfontinfo kana.otf enclosed.otf rotcjk.otf rotkana.otf #{fontDB.execute("SELECT fontFile FROM subFont WHERE lgcFontTag IS NOT NULL").flatten.join(" ")}
	$(MERGEFONTS) -cid cidfontinfo $@ #{cidmap.gsub(/\r?\n/, " ")}

#{iscygwin ? <<CYGWIN
#{target}: #{target.sub(/\..+?$/, '.raw')}
	$(MAKEOTF) -f $< -ff ../otf-features -mf ../fontMenuDB -o $@ -ch $(CMAP_HORIZONTAL)
	stat #{target} > /dev/null
CYGWIN
: <<LINUX
tmpcid.otf: #{target.sub(/\..+?$/, '.raw')}
	$(MAKEOTF) -f $< -ff ../otf-features -mf ../fontMenuDB -o $@ -ch $(CMAP_HORIZONTAL)
	stat $@ > /dev/null
tmpcid.ttx: tmpcid.otf
	ttx -o $@ $<
	stat $@ > /dev/null
#{target.sub(/\..+?$/, '.ttx')}: tmpcid.ttx
	sed -f ../fixotf.sed $< > $@
#{target}: #{target.sub(/\..+?$/, '.ttx')}
	ttx -o $@ $<
	stat $@ > /dev/null
LINUX
}
cidfontinfo:
	../makecfi.rb '#{enName}' '#{enWeight}' > $@

clean:
	-rm -rf $(TARGETS) *.scr *.log build *.otf work*.sfd kana*.sfd rot*.sfd *.js \
	temp.bmp temp.png temp.svg current.fpr _WORKDATA_* _WATCHDOG_*
FINIS
