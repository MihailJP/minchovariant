#!/usr/bin/env fontforge

import fontforge
from sys import argv, stderr

if len(argv) < 4:
	stderr.write("Usage: "+argv[0]+" encloser enclosed outfile\n")
	quit(1)

srcFont = fontforge.open(argv[1])
addFont = fontforge.open(argv[2])

for srcGlyph in srcFont.glyphs():
	if srcGlyph.isWorthOutputting():
		gNum = srcGlyph.unicode
		try:
			if addFont[gNum + 0x8000].isWorthOutputting():
				addFont.selection.select(("encoding",), gNum + 0x8000)
				addFont.copy()
				srcFont.selection.select(("encoding",), gNum)
				srcFont.pasteInto()
		except TypeError:
			pass
		srcGlyph.removeOverlap()

srcFont.generate(argv[3])
