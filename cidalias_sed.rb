#!/usr/bin/env ruby

print "$a \\\n"
lines = $stdin.read.split(/\r?\n/)
for l in 0...(lines.length) do
	print lines[l] + (l < (lines.length - 1) ? "\\" : "") + "\n"
end
