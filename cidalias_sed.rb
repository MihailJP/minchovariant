#!/usr/bin/env ruby

require 'sqlite3'
require 'set'

lgcGlyphs = SortedSet.new()
processed = SortedSet.new()
db = SQLite3::Database.open("HZMincho.db", {:readonly=>true})
['pwid', 'hwid', 'qwid', 'twid', 'fwid', 'ital',
'rotPwid', 'rotHwid', 'rotQwid', 'rotTwid', 'rotItal'].each {|tag|
	lgcGlyphs += db.execute("select #{tag} from lgcglyphs where #{tag} is not null").flatten
}
for fontID in db.execute("select FontID, procBaseFont, lgcFontTag from subFont") do
	if (fontID[1].nil?) && !(fontID[2].nil?) then
		lgcGlyphs += db.execute("select cid from cjkCID where fontID == ?", fontID[0]).flatten
	else
		lgcGlyphs -= db.execute("select cid from cjkCID where fontID == ?", fontID[0]).flatten
	end
end

if $0 =~ /sed/ then
	print "$a \\\n"
end
lines = $stdin.read.split(/\r?\n/)
for l in 0...(lines.length) do
	unless lgcGlyphs.member?(lines[l].split("\t")[0][1..-1].hex - 0xf0000) then
		if processed.add?(lines[l].split("\t")[0]) then
			print lines[l] + ($0 =~ /sed/ ? (l < (lines.length - 1) ? "\\" : "") : "") + "\n"
		end
	end
end
