#!/usr/bin/env ruby

if ARGV.length < 2 then
	STDERR.write("Usage: #{$0} infile outfile\n")
	exit(1)
end

while true
	system("#{File.dirname(__FILE__)}/merge-contours.py", ARGV[0], ARGV[1])
	stat = $?.exitstatus
	case stat
	when 0, 1, 130
		exit(stat)
	end
end
