#!/usr/bin/env ruby

AFD_DIR='/cygdrive/c/Apps/FDK' # Needed for Cygwin, otherwise meaningless
require 'sqlite3'
DBFileName = 'HZMincho.db'
if not File.exist?(DBFileName) then raise IOError, "Database '#{DBFileName}' not found" end
fontDB = SQLite3::Database.new(DBFileName)

(target, $weightNum, enName, enWeight, jaName, jaWeight, glyphFilter) = ARGV
license = 'Created by KAGE system. (http://fonts.jp/) / Alphabet glyphs by Andrey V. Panov (C) 2005 All rights reserved. / A few symbol glyphs are from George Doulos\\\' Symbola font. / AJ1-6 sans-serif glyphs from M+ fonts.'
psName = "#{enName} #{enWeight}".gsub(/\s/, "-")
cidmap = ""
fontDB.execute("SELECT mapFile, fontFile FROM subFont") {|subFont|
	cidmap += "../#{subFont[0]} #{eval("\"#{subFont[1]}\"")}\n"
}

def lgcFile(file, suffix)
	return <<FINIS
#{file}: ../LGC/lgc#{$weightNum.to_i % 100}#{suffix}.otf
	cp $^ $@
../LGC/lgc#{$weightNum.to_i % 100}#{suffix}.otf:
	cd ../LGC && $(MAKE) lgc#{$weightNum.to_i % 100}#{suffix}.otf
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
		return path
	end
end

print <<FINIS
AFD_DIR=#{iscygwin ? AFD_DIR : '~/bin/FDK'}
AFD_BINDIR=$(AFD_DIR)/Tools/#{iscygwin ? 'win' : 'linux'}
AFD_CMAPDIR=$(AFD_DIR)/Tools/SharedData/Adobe Cmaps/Adobe-Japan1
CMAP_HORIZONTAL=#{cygPath "$(AFD_CMAPDIR)/UniJIS2004-UTF32-H"}
CMAP_VERTICAL=#{cygPath "$(AFD_CMAPDIR)/UniJIS2004-UTF32-V"}
MERGEFONTS=$(AFD_BINDIR)/mergeFonts
MAKEOTF=#{iscygwin ? 'cmd /c ' : ''}#{cygPath "$(AFD_BINDIR)/makeotf#{iscygwin ? '.cmd' : ''}"}

TARGETS=head.txt parts.txt foot.txt engine makeglyph.js makettf.pl \
work.sfd work2.sfd work3.sfd work.otf #{target.sub(/\..+?$/, '.raw')} cidfontinfo #{target}

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
parts.txt:
	cat ../dump_newest_only.txt ../dump_all_versions.txt | ../mkparts.pl | sed -f #{glyphFilter} > $@
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
work3.sfd: work2.sfd
	../fixup-layers.py $< $@
work.otf: work2.sfd
	../width.py $< $@

rotcjk.sfd: work.otf
	../LGC/rotate.py $< $@
rotcjk.otf: rotcjk.sfd
	../rotcid.py $< $@

#{lgcFiles(fontDB)}

enclosed.otf: enclosed-base.otf work.otf
	../enclose.py $^ $@
ruby.otf: ruby-base.otf work.otf
	../enclose.py $^ $@
kanap.otf: kanap-base.otf work.otf
	../proportional.py $^ $@
kanavp.otf: kanavp-base.otf work.otf
	../proportional-vert.py $^ $@

#{target.sub(/\..+?$/, '.raw')}: work.otf cidfontinfo enclosed.otf rotcjk.otf #{fontDB.execute("SELECT fontFile FROM subFont WHERE lgcFontTag IS NOT NULL").flatten.join(" ")}
	$(MERGEFONTS) -cid cidfontinfo $@ #{cidmap.gsub(/\r?\n/, " ")}

#{target}: #{target.sub(/\..+?$/, '.raw')}
	$(MAKEOTF) -f $< -ff ../otf-features -mf ../fontMenuDB -o $@ -ch $(CMAP_HORIZONTAL) -cv $(CMAP_VERTICAL)
	stat #{target} > /dev/null

cidfontinfo:
	../makecfi.rb '#{enName}' '#{enWeight}' > $@

clean:
	-rm -rf $(TARGETS) work.scr work.log build *.otf
FINIS
