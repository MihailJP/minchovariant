#!/usr/bin/env fontforge

import fontforge
from sys import argv, stderr
from os import system

if len(argv) < 3:
	stderr.write("Usage: "+argv[0]+" infile outfile\n")
	quit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

font = fontforge.open(argv[1])
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		glyph.export("temp.png", 1024, 1)
		if system("convert temp.png temp.bmp"):
			raise RuntimeError
		if system("potrace -s temp.bmp"):
			raise RuntimeError
		glyph.layers[1] = fontforge.layer()
		glyph.importOutlines("temp.svg")
		glyph.simplify()
font.save(argv[2])
font.close()
