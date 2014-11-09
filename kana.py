#!/usr/bin/env fontforge

import fontforge, psMat
from sys import argv, stderr

if len(argv) < 5:
	stderr.write("Usage: "+argv[0]+" weight source-kana-1 source-kana-2 outfile\n")
	quit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

def getFrac(weight):
	if weight % 100 == 1:
		return -.4
	elif weight % 100 == 3:
		return 0.0
	elif weight % 100 == 5:
		return 0.4
	elif weight % 100 == 7:
		return 0.8
	elif weight % 100 == 9:
		return 1.2
	else:
		raise ValueError, "Unknown weight " + str(weight) + "specified"

origFont = fontforge.open(argv[2])
srcFont = origFont.interpolateFonts(getFrac(int(argv[1])), argv[3])

for glyph in srcFont.glyphs():
	if glyph.isWorthOutputting():
		glyph.comment = origFont[glyph.glyphname].comment
		glyph.removeOverlap()
		glyph.round()

srcFont.save(argv[4])
