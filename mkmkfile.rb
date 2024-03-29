#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/credits.rb"

require 'sqlite3'
DBFileName = 'HZMincho.db'
if not File.exist?(DBFileName) then raise IOError, "Database '#{DBFileName}' not found" end
fontDB = SQLite3::Database.new(DBFileName)

(target, $font, $weightNum, enName, enWeight, jaName, jaWeight) = ARGV
license = fontCopyrightOf(enName).gsub(/\n/, " / ").gsub(/'/, "\\\\'")
psName = "#{enName} #{enWeight}".gsub(/\s/, "-")
cidmap = ""
fontDB.execute("SELECT mapFile, fontFile FROM subFont") {|subFont|
	cidmap += "../#{subFont[0]} #{eval("\"#{subFont[1]}\"")}\n"
}

$LGCdir = ($font == "gothic" ? "Goth-LGC" : $font == "socho" ? "FS-LGC" : "LGC")

def lgcFile(file, suffix)
	return <<FINIS
.DELETE_ON_ERROR: #{file}
.INTERMEDIATE: #{file}
#{file}:
	cd ../#{$LGCdir} && $(MAKE) lgc#{$weightNum.to_i % 100}#{suffix}.otf
	ln -s ../#{$LGCdir}/lgc#{$weightNum.to_i % 100}#{suffix}.otf $@
FINIS
end

def lgcFiles(db)
	result = ""
	db.execute("SELECT fontFile, procBaseFont, tSuffix FROM subFont JOIN lgcFont ON lgcFontTag = fontTag WHERE lgcFontTag IS NOT NULL") {|subFont|
		result += lgcFile((subFont[1] or subFont[0]), subFont[2])
	}
	return result
end

def heavyFont?
	($font != "socho") and ($weightNum.to_i % 100 == 9)
end

def partsSrc
	if $font == "gothic" then
		"parts-gothic.txt"
	elsif $font == "socho" then
		"parts-socho.txt"
	else
		"parts.txt"
	end
end

def mac?
	if RUBY_PLATFORM.downcase =~ /darwin/ then
		return true
	else
		return false
	end
end

print <<FINIS
AFD_CMAPDIR=../cmap-resources/Adobe-Japan1-7/CMap/
CMAP_HORIZONTAL=$(AFD_CMAPDIR)/UniJIS2004-UTF32-H
CMAP_VERTICAL=$(AFD_CMAPDIR)/UniJIS2004-UTF32-V

TARGETS=#{target}
GENERATABLES=$(TARGETS) #{heavyFont? ? "ratio.txt " : ""}head.txt parts.txt foot.txt engine makeglyph.js \
#{target.sub(/\..+?$/, '.raw')} cidfontinfo #{"tmpcid.otf tmpcid.ttx _" + target.sub(/\..+?$/, '.ttx')} _#{target}

.PHONY: all clean font mostlyclean
all: $(TARGETS)

.DELETE_ON_ERROR: $(GENERATABLES)

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
ratio.txt: ../parts.txt
	cat ../parts.txt | sed -e 's/\\\\@/@/g' | ../cntstroke.rb > $@
SUBRECIPE
: ""}../#{partsSrc}:
	cd .. && $(MAKE) #{partsSrc}
parts.txt:#{heavyFont? ? " ratio.txt" : ""} ../#{partsSrc}
	cat ../#{partsSrc} #{heavyFont? ? "| ../kage-width.rb -f $< " : ""}> $@
foot.txt:
	touch $@
engine:
	ln -s ../engine $@
makeglyph.js:
	ln -s ../makeglyph/makeglyph.js $@

.INTERMEDIATE: work_.sfd work_.scr work2_.sfd work2.sfd temp.otf
.DELETE_ON_ERROR: work_.sfd work.sfd work_.sfd work2_.sfd work2.sfd temp.otf work.otf
work_.scr: head.txt parts.txt foot.txt engine makeglyph.js
	../makesvg.py . work_ #{$font} #{$weightNum}
work_.sfd: work_.scr
	cd build; $(MAKE) -j`#{mac? ? "getconf _NPROCESSORS_ONLN" : "nproc"}`
	export LANG=utf-8; fontforge -script work_.scr >> work.log 2>&1
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

.INTERMEDIATE: kana_.sfd kana2_.sfd kana2.otf
.DELETE_ON_ERROR: kana_.sfd kana.sfd kana2_.sfd kana2.sfd kana2.otf kana.otf
kana_.sfd: work.sfd
	../kana.py $^ $@
kana.sfd: kana_.sfd
	../fixup-layers.py $< $@
kana2_.sfd: kana.sfd
	../smooth-contours.py $< $@
kana2.sfd: kana2_.sfd
	../fixup-layers.py $< $@
kana2.otf: kana2.sfd
	../width.py $< $@
kana.otf: kana2.otf
	fontforge -lang=ff -c 'Open("$<"); Generate("$@")'

.INTERMEDIATE: rotcjk.sfd
.DELETE_ON_ERROR: rotcjk.sfd rotcjk.otf
rotcjk.sfd: upright.otf
	../#{$LGCdir}/rotate.py $< $@
rotcjk.otf: rotcjk.sfd
	../rotcid.py 5 $< $@

.INTERMEDIATE: rotkana.sfd
.DELETE_ON_ERROR: rotkana.sfd rotkana.otf
rotkana.sfd: kana.otf
	../#{$LGCdir}/rotate.py $< $@
rotkana.otf: rotkana.sfd
	../rotcid.py 2 $< $@

#{lgcFiles(fontDB)}

.DELETE_ON_ERROR: enclosed.otf ruby.otf kanap.otf kanavp.otf
enclosed.otf: enclosed-base.otf kana.otf work.otf
	../enclose.py $^ $@
ruby.otf: ruby-base.otf kana.otf work.otf
	../enclose.py $^ $@
kanap.otf: kanap-base.otf kana.otf work.otf
	../proportional.py $^ $@
kanavp.otf: kanavp-base.otf kana.otf work.otf
	../proportional-vert.py $^ $@

#{$font == "socho" ? <<SOCHO
.INTERMEDIATE: upright_.sfd upright.sfd upright_.otf
.DELETE_ON_ERROR: upright_.sfd upright.sfd upright_.otf upright.otf
.DELETE_ON_ERROR: uprightruby.otf uprightp.otf uprightvp.otf
upright_.sfd: ../mincho#{($weightNum.to_i % 100)}/work.sfd
	../socho.py 0 $< $@
upright.sfd: upright_.sfd
	../fixup-layers.py $< $@
upright_.otf: upright.sfd
	../width.py $< $@
upright.otf: upright_.otf
	fontforge -lang=ff -c 'Open("$<"); Generate("$@")'
SOCHO
: <<MINCHO
.DELETE_ON_ERROR: upright.otf
.DELETE_ON_ERROR: uprightruby.otf uprightp.otf uprightvp.otf
upright.otf: work.otf
	ln -s $< $@
MINCHO
}
uprightruby.otf: ruby-base.otf kana.otf upright.otf
	../enclose.py $^ $@
uprightp.otf: kanap-base.otf kana.otf upright.otf
	../proportional.py $^ $@
uprightvp.otf: kanavp-base.otf kana.otf upright.otf
	../proportional-vert.py $^ $@

.INTERMEDIATE: rotming.sfd
.DELETE_ON_ERROR: rotming.sfd rotming.otf
rotming.sfd: ../mincho3/work.otf
	../#{$LGCdir}/rotate.py $< $@
rotming.otf: rotming.sfd
	../rotcid.py 18 $< $@

.INTERMEDIATE: #{target.sub(/\..+?$/, '.raw')}
#{target.sub(/\..+?$/, '.raw')}: cidfontinfo #{
	fontDB.execute("SELECT fontFile FROM subFont WHERE fontFile IS NOT NULL").flatten.map {|i| i =~ /#/ ? eval("\"#{i}\"") : i}.uniq.join(" ")
}
	mergefonts -cid cidfontinfo $@ #{cidmap.gsub(/\r?\n/, " ")}

.INTERMEDIATE: temp.bmp temp.png temp.svg

.INTERMEDIATE: _#{target} _#{target.sub(/\..+?$/, '.ttx')} tmpcid.ttx
tmpcid.otf: #{target.sub(/\..+?$/, '.raw')}
	makeotf -f $< -ff ../otf-features#{$font == "mincho" ? "" : "-#{$font}"} -mf ../fontMenuDB -o $@ -ch $(CMAP_HORIZONTAL)
	stat $@ > /dev/null
tmpcid.ttx: tmpcid.otf
	ttx -o $@ $<
	stat $@ > /dev/null
_#{target.sub(/\..+?$/, '.ttx')}: tmpcid.ttx
	../fixotf.rb -w #{enWeight} -c #{$font == "gothic" ? 2048 : 513} $< > $@
_#{target}: _#{target.sub(/\..+?$/, '.ttx')}
	ttx -o $@ $<
	stat $@ > /dev/null
#{target}: _#{target}
	../fix-table.py $< $@
cidfontinfo: ../makecfi.rb ../credits.rb
	../makecfi.rb '#{enName}' '#{enWeight}' > $@

mostlyclean:
	-rm -rf $(GENERATABLES) *.scr *.log *.otf work*.sfd kana*.sfd rot*.sfd *.js \
	temp.bmp temp.png temp.svg current.fpr _WORKDATA_* _WATCHDOG_*
clean: mostlyclean
	-rm -rf build
FINIS
