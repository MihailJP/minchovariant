#!/usr/bin/env ruby

$numerator = 1
$denominator = 1

require 'optparse'
opt = OptionParser.new
opt.on('-n VAL', '--numerator=VAL', 'numerator of width scale (default: 1)') {|val| $numerator = val.to_i}
opt.on('-d VAL', '--denominator=VAL', 'denominator of width scale (default: 1)') {|val| $denominator = val.to_i}

opt.parse!(ARGV)

while l = gets()
	l.chomp!
	if l =~ /^uf([0-9a-f]{4})\t/ then
		arg = l.split(":")
		for i in [3, 5]
			arg[i] = (arg[i].to_i * $numerator / $denominator).to_s
		end
		l = arg.join(":")
	end
	puts l
end
