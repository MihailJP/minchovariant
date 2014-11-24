#!/usr/bin/env fontforge

import fontforge
import psMat
from sys import argv, stderr

fontforge.setPrefs('CoverageFormatsAllowed', 1)

if len(argv) < 4:
	stderr.write("Usage: "+argv[0]+" ratio infile outfile\n")
	quit(1)

font = fontforge.open(argv[2])
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		glyphWidth = glyph.width
		glyph.transform(psMat.scale(float(argv[1]), 1.0), ("partialRefs", "round"))
		glyph.width = glyphWidth
font.save(argv[3])
