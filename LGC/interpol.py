#!/usr/bin/env fontforge

from sys import (argv, stderr)
import fontforge

if len(argv) < 5:
	stderr.write("Usage: %s filename weight-param reg-src bold-src\n" % argv[0])
	exit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

def val(string):
	try:
		return int(string)
	except ValueError:
		return float(string)

srcFont = fontforge.open(argv[3])
font = srcFont.interpolateFonts(val(argv[2]), argv[4])
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		glyph.round()
font.generate(argv[1], flags=('PfEd-colors',))
