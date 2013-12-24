#!/usr/bin/env ruby

require 'yaml'

FeatureDat = YAML.load(open('featmap.yml') {|f| f.read})
GlyphDat = YAML.load(open('glyphmap.yml') {|f| f.read})

print(open('feathead.txt') {|f| f.read})

FeatureDat.each {|featName, featDat|
	print("feature #{featName} {\n")
	featDat.each {|fName, field|
		GlyphDat.each {|gName, gDat|
			field.each {|fromTag|
				print("\tsub \\#{gDat[fromTag]} by \\#{gDat[fName]};\n") if gDat[fromTag] && gDat[fName]
			}
		}
		print("} #{featName};\n")
	}
}

print(open('featfoot.txt') {|f| f.read})
