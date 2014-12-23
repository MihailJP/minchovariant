#!/usr/bin/env fontforge

import fontforge
import psMat
from sys import argv, stderr
from GlyphComment import getfield

fontforge.setPrefs('CoverageFormatsAllowed', 1)

class GlyphList:
	def __init__(self, filename):
		import fileinput
		import os
		import re
		currdir = os.getcwd()
		try:
			os.chdir(os.path.dirname(__file__))
		except OSError:
			pass
		hwl = set()
		nwl = re.compile('\r?\n')
		for line in fileinput.input(filename):
			hwl.add(nwl.sub('', line))
		os.chdir(currdir)
		self.listDat = frozenset(hwl)

font = fontforge.open(argv[1])
hwl = GlyphList("groups/HALFWIDTH.txt").listDat
nsl = GlyphList("groups/NONSPACING.txt").listDat
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		kagename = getfield(glyph, "Kage")
		if kagename in nsl:
			glyph.transform(psMat.translate(0, -font.em), ("partialRefs", None))
			glyph.width = 0
		elif kagename in hwl:
			glyph.width = font.em / 2
		else:
			glyph.width = font.em
font.generate(argv[2])
