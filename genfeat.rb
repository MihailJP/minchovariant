#!/usr/bin/env ruby

require 'sqlite3'
DBFileName = 'HZMincho.db'
if not File.exist?(DBFileName) then raise IOError, "Database '#{DBFileName}' not found" end
fontDB = SQLite3::Database.new(DBFileName)
Features = fontDB.execute("SELECT featTag, isLarge, aalt FROM featureCode")

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
	winAscent         1000;
	winDescent         300;
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

feature aalt {
FINIS

Features.each {|featName|
	if featName[2] != 0 then
		print("\tfeature #{featName[0]};\n")
	end
}
print("} aalt;\n")

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

print("feature nalt {\n")
fontDB.execute("SELECT * FROM glyphLabels NATURAL JOIN enclosed ORDER BY CID;") {|cid|
	subExpr = ""
	for i in 2..(cid.length - 1)
		if cid[i] then subExpr += "\\#{cid[i]} " end
	end
	print "\tsub \\#{cid[1]} from [#{subExpr[0..-2]}];\n"
}
print("} nalt;\n")
