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
from os.path import exists
from commands import getoutput
import re
import threading
import urllib

if len(ARGV) != 5:
	print "Usage: makettf.pl WorkingDirectory WorkingName Shotai Weight"
	print "Shotai: mincho or gothic"
	print "Weight: 1 3 5 7"
	exit(1)

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

threads = []
semaphore = threading.Semaphore(max(1, int(getoutput('nproc'))))

LOG = open(WORKDIR+"/"+WORKNAME+".log", "a")

buhin = {}
targetDict = {}

##############################################################################

def render(target, partsdata, code):
	try:
		semaphore.acquire()
		svg = getoutput(" ".join([MAKEGLYPH, target, partsdata, SHOTAI, WEIGHT]))
		LOG.write(code+" : "+(" ".join([MAKEGLYPH, target, partsdata, SHOTAI, WEIGHT]))+"\n")
		svgBaseName = WORKDIR+"/build/"+code
		FH = open(svgBaseName+".raw.svg", "w")
		FH.write(svg)
		FH.close()
		if system("inkscape -z -a 0:0:200:200 -e {0}.png -w 1024 -h 1024 -d 1200 {0}.raw.svg".format(svgBaseName)): raise RuntimeError
		if system("convert {0}.png {0}.bmp".format(svgBaseName)): raise RuntimeError
		if system("potrace -s {0}.bmp -o {0}.svg".format(svgBaseName)): raise RuntimeError
	finally:
		unlink(svgBaseName+".raw.svg")
		unlink(svgBaseName+".png")
		unlink(svgBaseName+".bmp")
		semaphore.release()

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
	FH = open(WORKDIR+"/"+WORKNAME+".scr", "a")
	FH.write(textbuf)
	FH.close()
	
	system("export LANG=utf-8; {0} -script {1}/{2}.scr >> {1}/{2}.log 2>&1".format(FONTFORGE, WORKDIR, WORKNAME))

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
	FH = open(WORKDIR+"/"+HEADER_FILENAME, "r")
	FH2 = open(WORKDIR+"/"+WORKNAME+".scr", "a")
	for line in FH:
		FH2.write(line)
	FH.close()
	FH2.close()

	LOG.write("Prepare header file ... done.\n")
else:
	LOG.write("No header file.\n")
	LOG.close()
	exit(2)

# parse buhin
temp = []
if exists(WORKDIR+"/"+PARTS_FILENAME):
	FH = open(WORKDIR+"/"+PARTS_FILENAME, "r")
	temp = FH.readlines()
	FH.close()
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
GLYPHLIST = open("../glyphs.txt", "r") # or die "Cannot read the glyph list"
for line in GLYPHLIST:
	name = re.sub(r"\r?\n$", "", line)
	target = re.sub(r"^[uU]0*", "", name) # delete zero for the beginning
	targetDict[target] = name
GLYPHLIST.close()
LOG.write("Prepare target code point ... done.\n")

# make glyph for each target
LOG.write("Prepare each glyph.\n")

targets = targetDict.keys(); targets.sort()
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
	thread = threading.Thread(target=render, args=(target, partsdata, code))
	thread.start()
	threads += [thread]
	addglyph(code, refGlyph, target)
for thread in threads:
	thread.join()
LOG.write("Prepare each glyph ... done.\n")

# scripts footer
if exists(WORKDIR+"/"+FOOTER_FILENAME):
	FH = open(WORKDIR+"/"+FOOTER_FILENAME, "r")
	FH2 = open(WORKDIR+"/"+WORKNAME+".scr", "a")
	for txtbuf in FH:
		FH2.write(txtbuf)
	FH.close()
	FH2.close()
	
	LOG.write("Prepare footer file ... done.\n")
else:
	LOG.write("No footer file.\n")
	LOG.close()
	exit(2)

LOG.close()
makefont()
