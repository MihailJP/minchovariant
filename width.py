#!/usr/bin/env fontforge

import fontforge
import psMat
from sys import argv, stderr

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

def getfield(glyph, key):
	import re
	nwl = re.compile('\r?\n')
	field = re.compile(r'^\s*([\w\-]+)\s*:\s*(.+?)\s*$')
	rawlist = nwl.split(glyph.comment)
	fields = {}
	for line in rawlist:
		(name, value) = field.match(line).group(1, 2)
		fields[name] = value
	return fields[key]

font = fontforge.open(argv[1])
hwl = GlyphList("groups/HALFWIDTH.txt").listDat
nsl = GlyphList("groups/NONSPACING.txt").listDat
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		kagename = getfield(glyph, "Kage")
		if kagename in nsl:
			glyph.transform(psMat.translate(0, -1000), ("partialRefs", None))
			glyph.width = 0
		elif kagename in hwl:
			glyph.width /= 2
font.generate(argv[2])
