#!/usr/bin/env fontforge

import fontforge
import psMat
from sys import argv, stderr
from GlyphComment import getfield

fontforge.setPrefs('CoverageFormatsAllowed', 1)

if len(argv) < 4:
	stderr.write("Usage: "+argv[0]+" ratio infile outfile\n")
	quit(1)

widthScale = None
widthList = {}
try:
	widthScale = float(argv[1])
except ValueError:
	import csv
	reader = csv.reader(open(argv[1]), delimiter='\t')
	for data in reader:
		widthList[data[0]] = float(data[3])

font = fontforge.open(argv[2])
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		kagename = getfield(glyph, "Kage")
		glyphWidth = glyph.width
		glyphScale = widthList[kagename] if kagename in widthList else widthScale
		if glyphScale != 1.0:
			glyph.transform(psMat.scale(glyphScale, 1.0), ("partialRefs", "round"))
		glyph.width = glyphWidth
font.save(argv[3])
