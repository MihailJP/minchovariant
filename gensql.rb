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
	elsif l.chomp =~ /^-- CJKROT (\d+) (\d+) (\d+) (\d+)/ then
		srcBegin = Regexp.last_match[1].to_i
		srcEnd = Regexp.last_match[2].to_i
		targetBegin = Regexp.last_match[3].to_i
		targetEnd = targetBegin + srcEnd - srcBegin
		cjkRotOffset[(srcBegin..srcEnd)] = targetBegin - srcBegin
		for i in (targetBegin)..(targetEnd)
			print("INSERT INTO cjkCID VALUES(#{i}, #{Regexp.last_match[4].to_i});\n")
		end
	elsif l.chomp == "-- CJKROT RECALL" then
		for srcRange in cjkRotOffset
			for i in srcRange[0]
				print("INSERT INTO vrt2 VALUES(#{i}, #{i+srcRange[1]});")
			end
		end
	else
		print(l)
	end
end
