#!/usr/bin/env ruby

$numerator = 1
$denominator = 1

@filelist = {}

require 'csv'

require 'optparse'
opt = OptionParser.new
opt.on('-n', '--numerator=VAL', 'numerator of width scale (default: 1)') {|val| $numerator = val.to_i}
opt.on('-d', '--denominator=VAL', 'denominator of width scale (default: 1)') {|val| $denominator = val.to_i}
opt.on('-f', '--file=FILENAME', 'read width scale of each glyph from file') {|filename|
	CSV.foreach(filename, col_sep: "\t") {|row|
		@filelist[row[0]] = row[2].to_f
	}
}
opt.parse!(ARGV)

while l = gets()
	l.chomp!
	if l =~ /^uf([0-9a-f]{4})\t/ then
		glyphName = l.split("\t")[0]
		arg = l.split("\t")[1].split(":")
		for i in [3, 5]
			if @filelist.empty? then
				arg[i] = (arg[i].to_f * $numerator / $denominator).round.to_s
			else
				arg[i] = (arg[i].to_f * @filelist[glyphName]).round.to_s
			end
		end
		l = "#{glyphName}\t#{arg.join(":")}"
	end
	puts l
end
