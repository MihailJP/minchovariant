#!/usr/bin/env python
# -*- coding: utf-8 -*-

FONTFORGE = "export LANG=utf-8; env fontforge"
MAKEGLYPH = "/usr/bin/js ./makeglyph.js"
MV = "/bin/mv"
HEADER_FILENAME = "head.txt"
PARTS_FILENAME = "parts.txt"
FOOTER_FILENAME = "foot.txt"
TEMPNAME = "temp"

from sys import exit, argv as ARGV
from os import system
from os.path import exists, dirname
from commands import getoutput
import re
import urllib
from os.path import join as pathjoin
import sqlite3

if len(ARGV) != 5:
	print "Usage: makettf.pl WorkingDirectory WorkingName Shotai Weight"
	print "Shotai: mincho or gothic"
	print "Weight: 1 3 5 7"
	exit(1)

dbFileName = pathjoin(dirname(ARGV[0]), "HZMincho.db")
if not exists(dbFileName):
	raise IOError(2, "Database '%s' not found" % (dbFileName,))

KumimojiGlyphs = set()
with sqlite3.connect(dbFileName) as db:
	for cids in db.execute('select horizontal, vertical, horizontalAlt, verticalAlt from cjkKumimoji;'):
		for cid in cids:
			if cid is not None:
				KumimojiGlyphs.add(cid)

def unlink(filename):
	import os, errno
	try:
		os.unlink(filename)
	except OSError:
		pass

def mkdir(dirname):
	import os, errno
	try:
		os.mkdir(dirname)
	except OSError:
		pass

(WORKDIR, WORKNAME, SHOTAI, WEIGHT) = ARGV[1:5]

unlink(WORKDIR+"/"+WORKNAME+".log")
unlink(WORKDIR+"/"+WORKNAME+".scr")
unlink(WORKDIR+"/"+WORKNAME+".ttf")
mkdir(WORKDIR+"/build")

LOG = open(WORKDIR+"/"+WORKNAME+".log", "a")

buhin = {}
targetDict = {}

##############################################################################

def adjustWeight(weight, code):
	if (int(code, 16) - 0xf0000) not in KumimojiGlyphs:
		return weight
	elif weight == 1:
		return 0
	elif weight == 3:
		return 1
	elif weight == 5 or weight == 105:
		return 3
	elif weight == 7:
		return 5
	elif weight == 107:
		return 105
	elif weight == 9:
		return 7
	elif weight == 109:
		return 107
	elif weight == 201:
		return 200
	elif weight == 203:
		return 201
	elif weight == 205:
		return 203
	elif weight == 207:
		return 205
	else:
		return weight

##############################################################################

def render(target, partsdata, code):
	LOG.write(code+" : "+(" ".join([MAKEGLYPH, target, partsdata, SHOTAI, str(adjustWeight(int(WEIGHT), code))]))+"\n")
	svgBaseName = WORKDIR+"/build/"+code
	svgcmd = "cd ..; " + (" ".join([MAKEGLYPH, target, partsdata, SHOTAI, str(adjustWeight(int(WEIGHT), code))])) + " > build/" + code + ".raw.svg; cd build"
	needsUpdate = False
	if not exists(svgBaseName+".sh"):
		needsUpdate = True
	else:
		with open(svgBaseName+".sh", "r") as FH:
			if FH.readline().rstrip('\n') != svgcmd:
				needsUpdate = True
	if needsUpdate:
		with open(svgBaseName+".sh", "w") as FH:
			FH.write(svgcmd + "\n")
			FH.write("inkscape -z -a 0:0:200:200 -e {0}.png -w 1024 -h 1024 -d 1200 {0}.raw.svg > /dev/null\n".format(code))
			FH.write("if [ $? -ne 0 ]; then exit 2; fi\n")
			FH.write("convert {0}.png -background white -flatten -alpha off {0}.bmp\n".format(code))
			FH.write("if [ $? -ne 0 ]; then exit 2; fi\n")
			FH.write("potrace -s {0}.bmp -o {0}.svg\n".format(code))
			FH.write("if [ $? -ne 0 ]; then exit 2; fi\n")
			FH.write("rm -f " + code+".raw.svg\n")
			FH.write("rm -f " + code+".png\n")
			FH.write("rm -f " + code+".bmp\n")

##############################################################################

def addglyph(code, refGlyph, target):
	textbuf = """Print(0u{0})
Select(0u{0})
Clear()
Import("{3}/build/{0}.svg")
Scale(500)
CanonicalContours()
CanonicalStart()
FindIntersections()
SetGlyphComment("Kage: {1}\\nAlias: {2}")
Simplify()
Scale(20)
SetWidth(1000)
RoundToInt()
AutoHint()
""".format(code, refGlyph, target, WORKDIR)
	while True:
		try:
			FH = open(WORKDIR+"/"+WORKNAME+".scr", "a")
		except IOError:
			continue
		FH.write(textbuf)
		FH.close()
		break

##############################################################################

def makefont():
	textbuf = "Save(\""+WORKDIR+"/"+WORKNAME+".sfd\")\n"
	textbuf += "Quit()\n"
	with open(WORKDIR+"/"+WORKNAME+".scr", "a") as FH:
		FH.write(textbuf)

##############################################################################

def addsubset(subset, target):
	subset[target] = buhin[target]
	txtbuf = '$'+buhin[target]+'$'
	for match in re.findall(r"(\$99:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^\$:]*)(?::[^\$]*)?)", txtbuf):
		if match[1] not in subset:
			addsubset(subset, match[1])

##############################################################################

# initialize
if exists(WORKDIR+"/"+HEADER_FILENAME):
	with open(WORKDIR+"/"+HEADER_FILENAME, "r") as FH:
		with open(WORKDIR+"/"+WORKNAME+".scr", "a") as FH2:
			for line in FH:
				FH2.write(line)

	LOG.write("Prepare header file ... done.\n")
else:
	LOG.write("No header file.\n")
	LOG.close()
	exit(2)

# parse buhin
temp = []
if exists(WORKDIR+"/"+PARTS_FILENAME):
	with open(WORKDIR+"/"+PARTS_FILENAME, "r") as FH:
		temp = FH.readlines()
	LOG.write("Prepare parts file ... done.\n")
else:
	LOG.write("No parts file.\n")
	LOG.close()
	exit(2)

for tmpdat in temp:
	if re.search(":", tmpdat):
		temp2 = re.split(r" +|\t", tmpdat)
		buhin[temp2[0]] = temp2[1]
LOG.write("Prepare parts data ... done.\n")

# parse target code point
with open("../glyphs.txt", "r") as GLYPHLIST: # or die "Cannot read the glyph list"
	for line in GLYPHLIST:
		name = re.sub(r"\r?\n$", "", line)
		target = re.sub(r"^[uU]0*", "", name) # delete zero for the beginning
		targetDict[target] = name
LOG.write("Prepare target code point ... done.\n")

# make glyph for each target
LOG.write("Prepare each glyph.\n")

targets = sorted(list(set(targetDict.keys())))
with open(WORKDIR+"/build/Makefile", "w") as FH:
	FH.write("TARGETS=\\\n")
	for code in targets:
		FH.write(code + ".svg \\\n")
	FH.write("""
.PHONY: all clean

all: $(TARGETS)

.SUFFIXES: .svg .sh
.sh.svg:
	sh $^

clean:
	rm -f *.svg *.bmp *.png
""")
for code in targets:
	#LOG.write(code+" : ")
	refGlyph = targetDict[code]
	subset = {}
	addsubset(subset, refGlyph)
	partsdata = ""
	for subsetKey in subset.keys():
		partsdata += subsetKey+" "+subset[subsetKey]+"\n"
	target = urllib.quote_plus(refGlyph.encode('utf-8'))
	partsdata = urllib.quote_plus(partsdata.encode('utf-8'))
	render(target, partsdata, code)
	addglyph(code, refGlyph, target)
LOG.write("Prepare each glyph ... done.\n")

# scripts footer
if exists(WORKDIR+"/"+FOOTER_FILENAME):
	with open(WORKDIR+"/"+FOOTER_FILENAME, "r") as FH:
		with open(WORKDIR+"/"+WORKNAME+".scr", "a") as FH2:
			for txtbuf in FH:
				FH2.write(txtbuf)
	
	LOG.write("Prepare footer file ... done.\n")
else:
	LOG.write("No footer file.\n")
	LOG.close()
	exit(2)

LOG.close()
makefont()
