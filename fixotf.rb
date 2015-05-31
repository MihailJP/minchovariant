#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$fontWeight = nil

require 'optparse'
opt = OptionParser.new
opt.on('-w', '--weight=STR', 'override font weight') {|val| $fontWeight = val}
opt.parse!(ARGV)

weightStr = false

while line = gets
	line.chomp!
	line.gsub! /Mincoo/, 'Mincho'
	line.gsub! /Soc[ho][-o]/, 'Socho'
	line.sub! /<fsType value="[01]{8} [01]{8}"\/>/, '<fsType value="00000000 00000000"/>'
	line.sub! /<sFamilyClass value="[[:digit:]]+"\/>/, '<sFamilyClass value="513"/>'
	line.sub! /<bFamilyType value="1?[[:digit:]]"\/>/, '<bFamilyType value="2"/>'
	if ($fontWeight) and (line =~ /<namerecord nameID="2"/) then
		weightStr = true
	elsif weightStr then
		line = "      #{$fontWeight}"
		weightStr = false
	end
	puts line
end
