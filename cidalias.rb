#!/usr/bin/env ruby

$stdin.each_line() {|line|
	m = /^ aj1-(\d+)\s/.match(line)
	begin
		gNum = m[1].to_s
		print "u#{(gNum.to_i + 0xf0000).to_s(16)}\t99:0:0:0:0:200:200:aj1-#{gNum}\n"
	rescue NoMethodError
	end
}
