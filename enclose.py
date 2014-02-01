#!/usr/bin/env fontforge

import fontforge, psMat
from sys import argv, stderr
from re import search
from math import pi

if len(argv) < 4:
	stderr.write("Usage: "+argv[0]+" encloser enclosed outfile\n")
	quit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

srcFont = fontforge.open(argv[1])
addFont = fontforge.open(argv[2])

proportionalFlag = (search('proportional', argv[0]) is not None)
verticalFlag = (search('vert', argv[0]) is not None)

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
						if verticalFlag:
							glyph.transform(psMat.translate(0, srcFont.descent))
							if glyph.color != 0xffff00: glyph.transform(psMat.rotate(pi / 2))
						try:
							glyph.left_side_bearing = 50
							glyph.right_side_bearing = 50
						except TypeError:
							glyph.left_side_bearing = 50L
							glyph.right_side_bearing = 50L
						if verticalFlag:
							w = glyph.width
							glyph.transform(psMat.rotate(-pi / 2))
							glyph.transform(psMat.translate(0, srcFont.ascent))
							glyph.width = srcFont.em
							glyph.vwidth = w
		except TypeError:
			pass
		srcGlyph.removeOverlap()

srcFont.generate(argv[3])
