#!/usr/bin/env ruby

require 'optparse'
op = OptionParser.new

op.parse!(ARGV)

@kagedat = {}
@cache = {}

def strokes(glyph)
	if not @cache.include?(glyph) then
		elements = @kagedat[glyph].split(/\$/)
		numOfStrokes = 0
		for element in elements
			if element =~ /^99:/ then
				begin
					refName = element.split(/:/)[7]
					numOfStrokes += strokes(refName)
				rescue NoMethodError
					newestVer = @kagedat.keys.select {|x| x.start_with?("#{refName}@")}.map {|x| x.split(/@/)[1].to_i}.max
					numOfStrokes += strokes("#{refName}@#{newestVer}")
				end
			else
				numOfStrokes += 1
			end
		end
		@cache[glyph] = numOfStrokes
	end
	@cache[glyph]
end

while l = gets
	l.chomp!
	(name, dat) = l.split(/\t/)
	@kagedat[name] = dat
end

glyphs = @kagedat.keys.select {|x| x =~ /^uf[0-9abcdef]{4}$/}

for glyph in glyphs
	numOfStrokes = strokes(glyph)
	ratio = (1.0 - (1.0 / (1.0 + Math::E ** (3.0 - 0.5 * numOfStrokes)))) * (1.75 - 1.125) + 1.125
	print "#{glyph}\t#{numOfStrokes}\t#{1.0 / ratio}\t#{ratio}\n"
end
