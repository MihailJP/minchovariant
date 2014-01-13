#!/usr/bin/env ruby

cjkRotOffset = {}
while l = STDIN.gets
	if l.chomp == "-- LIST OF TARGET CID" then
		for i in 0..23057
			print("INSERT INTO targetCIDs VALUES(#{i});\n")
		end
	elsif l.chomp =~ /^-- CJKCID (\d+) (\d+) (\d+)/ then
		for i in (Regexp.last_match[1].to_i)..(Regexp.last_match[2].to_i)
			print("INSERT INTO cjkCID VALUES(#{i}, #{Regexp.last_match[3].to_i});\n")
		end
	else
		print(l)
	end
end
