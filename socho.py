#!/usr/bin/env fontforge

import fontforge, psMat
from sys import argv, stderr
from os import system
from math import radians

if len(argv) < 4:
	stderr.write("Usage: "+argv[0]+" skew-flag infile outfile\n")
	quit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

font = fontforge.open(argv[2])
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		width = glyph.width
		glyph.transform(psMat.translate(-font.em / 2, 0))
		glyph.transform(psMat.scale(0.8, 1.0))
		if int(argv[1]):
			glyph.transform(psMat.rotate(radians(90)))
			glyph.transform(psMat.skew(radians(-4)))
			glyph.transform(psMat.rotate(radians(-90)))
		glyph.transform(psMat.translate(font.em / 2, 0))
		glyph.width = width
font.save(argv[3])
font.close()
