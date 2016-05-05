#!/usr/bin/env fontforge

import fontforge, psMat
from sys import argv, stderr
from os import path
import sqlite3

if len(argv) < 3:
	stderr.write("Usage: "+argv[0]+" source target\n")
	quit(1)

dbFileName = path.join(path.dirname(argv[0]), "HZMincho.db")
if not path.exists(dbFileName):
	raise IOError(2, "Database '%s' not found" % (dbFileName,))

KanaGlyphs = set()
with sqlite3.connect(dbFileName) as db:
	for cid in db.execute('select CID from cjkCID where fontID=1;'):
		KanaGlyphs.add(cid[0])

fontforge.setPrefs('CoverageFormatsAllowed', 1)

srcFont = fontforge.open(argv[1])
targetFont = fontforge.font()
targetFont.encoding = 'UnicodeFull'

srcFont.selection.none()
targetFont.selection.none()

for cid in KanaGlyphs:
	srcFont.selection.select(('more',), cid + 0xf0000)
	targetFont.selection.select(('more',), cid + 0xf0000)
srcFont.copy()
targetFont.paste()

for glyph in targetFont.glyphs():
	if glyph.isWorthOutputting():
		glyph.comment = srcFont[glyph.glyphname].comment
		glyph.removeOverlap()
		glyph.round()

targetFont.save(argv[2])
