#!/usr/bin/env ruby

OPTS = {}

require 'optparse'
options = OptionParser.new do |o|
	o.banner = "Usage: #{$0} [options] [glyph-name-list-file]"
	o.on('-d filename', '--data=filename', 'the file containing Kage glyph definitions') {|v| OPTS[:d] = v}
end
args = options.parse(ARGV)

def getKageData(filename)
	kagedat = ""; kage = {}
	open(filename) do |file| kagedat = file.read end
	kageLines = kagedat.split(/\r?\n/)
	for l in kageLines do
		begin
			name, rel, glyph = /^ ([\w\-]+)\s*\|\s*([\w\-]+)\s*\|\s*(\S+)\s*$/.match(l).captures
			kage[name] = {'rel' => rel, 'dat' => glyph}
		rescue NoMethodError
			# do nothing
		end
	end
	return kage
end

open((args[0] or '/dev/stdin')) do |file|
	kage = getKageData((OPTS[:d] or "dump_newest_only.txt"))
	lines = file.read.split(/\r?\n/)
	r = Regexp.new("^(#{lines.join('|')})\-u(fe0|e01[0-9a-e])[0-9da-f]$")
	for i in kage.keys do
		if r === i then
			puts i
		end
	end
end
