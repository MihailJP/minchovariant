#!/usr/bin/env ruby

$stdin.each_line() {|line|
	m = /^(\d{5})\s(\S+)/.match(line)
	begin
		gNum = m[1].to_s
		print "u#{(gNum.to_i + 0xf0000).to_s(16)}\t99:0:0:0:0:200:200:#{m[2].to_s}\n"
	rescue NoMethodError
	end
}
