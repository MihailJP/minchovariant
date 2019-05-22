#!/usr/bin/env fontforge

import fontforge, psMat
from sys import argv, stderr
from re import search
from math import pi

if len(argv) < 4:
	stderr.write("Usage: "+argv[0]+" encloser enclosed [...] outfile\n")
	quit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

srcFont = fontforge.open(argv[1])
addFonts = []
for i in range(2, len(argv)-1):
	addFonts += [fontforge.open(argv[i])]

proportionalFlag = (search('proportional', argv[0]) is not None)
verticalFlag = (search('vert', argv[0]) is not None)

for srcGlyph in srcFont.glyphs():
	if srcGlyph.isWorthOutputting():
		gNum = srcGlyph.unicode
		for addFont in addFonts:
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
							glyph.left_side_bearing = 50
							glyph.right_side_bearing = 50
							if verticalFlag:
								w = glyph.width
								glyph.transform(psMat.rotate(-pi / 2))
								glyph.transform(psMat.translate(0, srcFont.ascent))
								glyph.width = srcFont.em
								glyph.vwidth = w
					break
			except TypeError:
				pass
		else:
			stderr.write("Glyph ID " + str(gNum & 0x7fff) + " not found\n")
		srcGlyph.removeOverlap()

srcFont.generate(argv[-1])
