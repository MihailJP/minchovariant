#!/usr/bin/env ruby

if ARGV.length < 1 then
	STDERR.write("Usage: #{$0} tagName\n")
	exit(1)
end

require 'yaml'

NameDat = YAML.load(open('lgcmapnm.yml') {|f| f.read})
GlyphDat = YAML.load(open('glyphmap.yml') {|f| f.read})

lines = []

print("mergeFonts #{NameDat[ARGV[0]]}\n")
GlyphDat.each {|gName, gDat|
	lines.push(sprintf("%05d\t%s\n", gDat[ARGV[0]], gName)) if gDat[ARGV[0]]
}
lines.sort.each {|line| print(line)}
