#!/usr/bin/env ruby

print("mergeFonts All\n")
for i in 0..23057 do
	print("#{'%05d' % i} u#{(i + 0xf0000).to_s(16).upcase}\n")
end
