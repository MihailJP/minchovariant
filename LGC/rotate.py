#!/usr/bin/env fontforge

from sys import argv, stderr
import fontforge, psMat, math

if len(argv) < 3:
	stderr.write("Usage: %s in-sfd out-sfd\n" % argv[0])
	exit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

font = fontforge.open(argv[1])
font.hasvmetrics = True

font.selection.none()
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		font.selection.select(("more",), glyph)
font.unlinkReferences()

for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		w = glyph.width
		glyph.transform(psMat.rotate(-(math.pi / 2.0)))
		glyph.transform(psMat.translate(font.descent, font.ascent))
		glyph.width = font.em
		glyph.vwidth = w
		glyph.round()

font.save(argv[2])
