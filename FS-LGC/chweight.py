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
		if amount != 0:
			glyph.changeWeight(amount, "auto", 0, 0, chwType)
		glyph.round()
font.generate(argv[1], flags=('PfEd-colors',))
