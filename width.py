#!/usr/bin/env fontforge

import fontforge
import psMat
from sys import argv, stderr
from os import path
from GlyphComment import getfield
import sqlite3

fontforge.setPrefs('CoverageFormatsAllowed', 1)

dbFileName = path.join(path.dirname(argv[0]), "HZMincho.db")
if not path.exists(dbFileName):
	raise IOError(2, "Database '%s' not found" % (dbFileName,))

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
with sqlite3.connect(dbFileName) as db:
	for glyph in font.glyphs():
		if glyph.isWorthOutputting():
			kagename = getfield(glyph, "Kage")
			widthType = db.execute(u"SELECT CID, widthType FROM widthData WHERE CID="+str(glyph.encoding & 0x7fff)+";").fetchone()[1]
			if kagename in nsl:
				glyph.transform(psMat.translate(0, -font.em), ("partialRefs", None))
				glyph.width = 0
			elif (kagename in hwl) or (widthType == 1) or (widthType == 2 and glyph.boundingBox()[2] <= font.em / 2):
				glyph.width = font.em // 2
			elif widthType == 3:
				glyph.width = font.em // 4
			elif widthType == 4:
				glyph.width = font.em // 3
			else:
				glyph.width = font.em
font.generate(argv[2])
