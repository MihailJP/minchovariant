#!/usr/bin/env ruby

require 'yaml'

FeatureDat = YAML.load(open('featmap.yml') {|f| f.read})
GlyphDat = YAML.load(open('glyphmap.yml') {|f| f.read})

print(open('feathead.txt') {|f| f.read})

FeatureDat.each {|featName, featStyle|
	print("feature #{featName} {\n")
	featStyle.each {|featStyleName, featDat|
		if featStyleName == 'font-to-font' then
			featDat.each {|fName, field|
				GlyphDat.each {|gName, gDat|
					field.each {|fromTag|
						print("\tsub \\#{gDat[fromTag]} by \\#{gDat[fName]};\n") if gDat[fromTag] && gDat[fName]
					}
				}
			}
		elsif featStyleName == 'glyph-to-glyph' then
			featDat.each {|glyph|
				GlyphDat[glyph['from']].each {|gName, gDat|
					print("\tsub \\#{GlyphDat[glyph['from']][gName]} by \\#{GlyphDat[glyph['to']][gName]};\n") if GlyphDat[glyph['from']][gName] && GlyphDat[glyph['to']][gName]
				}
			}
		end
	}
	print("} #{featName};\n")
}

print(open('featfoot.txt') {|f| f.read})
