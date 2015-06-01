#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$fontWeight = nil

require 'optparse'
opt = OptionParser.new
opt.on('-w', '--weight=STR', 'override font weight') {|val| $fontWeight = val}
opt.parse!(ARGV)

JapaneseWeight = {
	'Light' => "&##{0x7d30};",
	'Book'  => "&##{0x6a19};&##{0x6e96};",
	'Demi'  => "&##{0x4e2d};&##{0x592a};",
	'Bold'  => "&##{0x592a};",
	'Heavy' => "&##{0x6975};&##{0x592a};",
}
MacWeight = {
	'Light' => "&##{0x8d};&##{0xd7};",
	'Book'  => "&##{0x95};&##{0x57};&##{0x8f};&##{0x80};",
	'Demi'  => "&##{0x92};&##{0x86};&##{0x91};&##{0xbe};",
	'Bold'  => "&##{0x91};&##{0xbe};",
	'Heavy' => "&##{0x8b};&##{0xc9};&##{0x91};&##{0xbe};",
}

weightHdr = nil
fNameHdr = nil

while line = gets
	line.chomp!
	line.gsub! /Mincoo/, 'Mincho'
	line.gsub! /Soc[ho][-o]/, 'Socho'
	line.sub! /<fsType value="[01]{8} [01]{8}"\/>/, '<fsType value="00000000 00000000"/>'
	line.sub! /<sFamilyClass value="[[:digit:]]+"\/>/, '<sFamilyClass value="513"/>'
	line.sub! /<bFamilyType value="1?[[:digit:]]"\/>/, '<bFamilyType value="2"/>'
	if ($fontWeight) and (line =~ /<namerecord nameID="2"/) then
		weightHdr = line
	elsif weightHdr then
		if weightHdr =~ /langID="0x411"/ then
			line = "      #{JapaneseWeight[$fontWeight]}"
		elsif weightHdr =~ /langID="0xb"/ then
			line = "      #{MacWeight[$fontWeight]}"
		else
			line = "      #{$fontWeight}"
		end
		weightHdr = nil
	end
	if ($fontWeight) and (line =~ /<namerecord nameID="4"/) then
		fNameHdr = line
	elsif fNameHdr then
		if fNameHdr =~ /langID="0x411"/ then
			line += " #{JapaneseWeight[$fontWeight]}"
		elsif fNameHdr =~ /langID="0xb"/ then
			line += " #{MacWeight[$fontWeight]}"
		else
			line += " #{$fontWeight}"
		end
		fNameHdr = nil
	end
	puts line
end
