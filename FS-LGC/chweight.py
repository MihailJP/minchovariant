#!/usr/bin/env fontforge

from sys import (argv, stderr)
import fontforge

if len(argv) < 5:
	stderr.write("Usage: %s filename weight-param type reg-src\n\n" % argv[0])
	stderr.write("Type: squish retain auto\n")
	exit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

amount = int(argv[2])
chwType = argv[3]
font = fontforge.open(argv[4])
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		if amount < 0: # NEGATIVE amount: debolden
			glyph.simplify()
			glyph.stroke("circular", -amount, "butt", "miter", ("removeinternal",))
			glyph.changeWeight(amount * 2, "auto", -68 * amount * 2, 10, chwType)
		elif amount > 0: # POSITIVE amount: embolden
			glyph.changeWeight(amount, "auto", 68, 10, chwType)
		glyph.round()
font.generate(argv[1], flags=('PfEd-colors',))
