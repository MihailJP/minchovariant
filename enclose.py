#!/usr/bin/env fontforge

import fontforge
from sys import argv, stderr
from re import search

if len(argv) < 4:
	stderr.write("Usage: "+argv[0]+" encloser enclosed outfile\n")
	quit(1)

srcFont = fontforge.open(argv[1])
addFont = fontforge.open(argv[2])

proportionalFlag = (search('proportional', argv[0]) is not None)

for srcGlyph in srcFont.glyphs():
	if srcGlyph.isWorthOutputting():
		gNum = srcGlyph.unicode
		try:
			if addFont[gNum + 0x8000].isWorthOutputting():
				addFont.selection.select(("encoding",), gNum + 0x8000)
				addFont.copy()
				srcFont.selection.select(("encoding",), gNum)
				srcFont.pasteInto()
				srcFont.correctDirection()
				if proportionalFlag:
					for glyph in srcFont.selection.byGlyphs:
						try:
							glyph.left_side_bearing = 50
							glyph.right_side_bearing = 50
						except TypeError:
							glyph.left_side_bearing = 50L
							glyph.right_side_bearing = 50L
		except TypeError:
			pass
		srcGlyph.removeOverlap()

srcFont.generate(argv[3])
