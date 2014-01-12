#!/usr/bin/env ruby

require 'sqlite3'
DBFileName = 'HZMincho.db'
if not File.exist?(DBFileName) then raise IOError, "Database '#{DBFileName}' not found" end
fontDB = SQLite3::Database.new(DBFileName)
Features = fontDB.execute("SELECT featTag, isLarge FROM featureCode")

print <<FINIS
table head {
	FontRevision     1.000;
} head;
table hhea {
	Ascender           800;
	Descender         -200;
	LineGap           1000;
} hhea;
table OS/2 {
	TypoAscender       800;
	TypoDescender     -200;
	TypoLineGap       1000;
} OS/2;
table vhea {
	VertTypoAscender   500;
	VertTypoDescender -500;
	VertTypoLineGap   1000;
} vhea;

languagesystem DFLT dflt;
languagesystem kana dflt;
languagesystem hani dflt;
languagesystem latn dflt;
languagesystem grek dflt;
languagesystem cyrl dflt;

FINIS

Features.each {|featName|
	if featName[1] != 0 then
		print("lookup #{featName[0]}Lookup useExtension {\n")
	else
		print("feature #{featName[0]} {\n")
	end
	fontDB.execute("SELECT base1, base2, base3, base4, base5, base6, base7, base8, target FROM features WHERE featTag = '#{featName[0]}'") {|featDat|
		print "\tsub "
		for i in 0...(featDat.length - 1)
			if featDat[i] then print "\\#{featDat[i]} " end
		end
		print "by \\#{featDat[-1]};\n"
	}
	if featName[1] != 0 then
		print("} #{featName[0]}Lookup;\nfeature #{featName[0]} {\n\tlookup #{featName[0]}Lookup;\n} #{featName[0]};\n")
	else
		print("} #{featName[0]};\n")
	end
}
