#!/usr/bin/env ruby

require 'set'

mode = ARGV[0]
lgcIDs = Set.new []

def excludeGlyphMap(lgcIDs, filename)
	open(filename) {|file|
		while l = file.gets
			p = l.split('\t')[0].to_i
			if p > 0 then lgcIDs.add(p) end
		end
	}
end
excludeGlyphMap(lgcIDs, "lgc.map")
excludeGlyphMap(lgcIDs, "lgc-fixed.map")
excludeGlyphMap(lgcIDs, "lgc-third.map")
excludeGlyphMap(lgcIDs, "lgc-quarter.map")
excludeGlyphMap(lgcIDs, "lgc-wide.map")

GlyphList = {
	"BlockElem" => [
		(425..500).to_a,
		(7479..7554).to_a,
		(8230..8258).to_a,
		(8261..8263).to_a
		].flatten,
	"Dingbats" => [
		690, 691, 722, 724, 727, 729, 731, 733, 740, 775, 778,
		7915, 7916, 8056, 8058, (8206..8222).to_a, 
		12099, 12100, 12194, 12195, 12238, 12239, 12259,
		16200, 16203, 16234, (16274..16277).to_a, 
		20366, 20957
		].flatten
}

print("mergeFonts #{mode or 'Japanese'}\n")
for i in mode ? GlyphList[mode] : 0..23057 do
	if not mode then
		flag = false
		for k in GlyphList.keys do flag |= GlyphList[k].member?(i) end
		if flag then next end
	end
	if not lgcIDs.include?(i) then
		print("#{'%05d' % i} u#{(i + 0xf0000).to_s(16).upcase}\n")
	end
end
