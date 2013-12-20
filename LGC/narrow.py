#!/usr/bin/env fontforge

from sys import argv, stderr
import fontforge, psMat

if len(argv) < 3:
	stderr.write("Usage: %s in-sfd out-sfd compress-ratio\n" % argv[0])
	exit(1)

font = fontforge.open(argv[1])
font.hasvmetrics = True

for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		w = glyph.width
		glyph.transform(psMat.scale(float(argv[3]), 1.0))
		glyph.width = font.em
		glyph.vwidth = w

font.save(argv[2])
