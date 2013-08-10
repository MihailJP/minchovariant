#!/usr/bin/env ruby

mode = ARGV[0]

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

print("mergeFonts #{mode or 'All'}\n")
for i in mode ? GlyphList[mode] : 0..23057 do
	if not mode then
		flag = false
		for k in GlyphList.keys do flag |= GlyphList[k].member?(i) end
		if flag then next end
	end
	print("#{'%05d' % i} u#{(i + 0xf0000).to_s(16).upcase}\n")
end
