#!/usr/bin/env fontforge

import fontforge, psMat
from sys import argv, stderr
from math import hypot
from os.path import splitext
import shelve

if len(argv) < 3:
	stderr.write("Usage: "+argv[0]+" infile outfile\n")
	quit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

def determineMinDist(glyph):
	minDist = float('inf')
	for contour in glyph.layers[1]:
		lastCoord = (contour[-1].x, contour[-1].y)
		for point in contour:
			dist = hypot(point.x - lastCoord[0], point.y - lastCoord[1])
			lastCoord = (point.x, point.y)
			if dist > 0 and dist < minDist:
				minDist = dist
	return minDist

def determineScaleFactor(minDist):
	if minDist <= 0:
		raise ValueError, "minDist not positive"
	scaleFactor = 1.0
	scaledDist = minDist
	while scaledDist < 0.125:
		scaleFactor *= 2.0
		scaledDist *= 2.0
		if scaleFactor >= 256.0:
			break
	return scaleFactor

def getInvertedContour(contour):
	newContour = fontforge.contour()
	for k in range(0, -len(contour), -1):
		newContour += contour[k]
	newContour.closed = True
	return newContour

def ensureContourIsClockwise(layer):
	l = fontforge.layer()
	for contour in layer:
		if contour.isClockwise() == 0:
			l += getInvertedContour(contour)
		else:
			if contour.isClockwise() == -1:
				stderr.write("Contour self-intersection detected\n")
			l += contour
	return l

def ensureNoSelfIntersection(layer):
	for contour in layer:
		if not contour.closed:
			raise RuntimeError, "Open contour detected"
		#elif contour.isClockwise() == -1:
		#	raise RuntimeError, "Contour self-intersection detected"

def doRemoveOverlaps(glyph, scaleFactor):
	try:
		glyph.transform(psMat.scale(scaleFactor))
		layer = ensureContourIsClockwise(glyph.layers[1])
		if not layer.isEmpty():
			newLayer = fontforge.layer()
			newLayer += layer[0]
			try:
				for i in range(1, len(layer)):
					newLayer += layer[i]
					newLayer.removeOverlap()
			except Exception, ex:
				print glyph.glyphname, ex
				if ex.args[0] != "Empty contour":
					raise
			if scaleFactor < 1024:
				ensureNoSelfIntersection(newLayer)
			else:
				stderr.write(glyph.glyphname + " ensuring all contours are closed...\n")
				for contour in newLayer:
					contour.closed = True
			glyph.layers[1] = newLayer
	finally:
		glyph.transform(psMat.scale(1.0/scaleFactor))

def removeOverlaps(glyph):
	minDist = determineMinDist(glyph)
	scaleFactor = determineScaleFactor(minDist)
	while True:
		try:
			doRemoveOverlaps(glyph, scaleFactor)
		except RuntimeError, ex:
			if ex.args[0] == "Open contour detected":
				stderr.write(glyph.glyphname + " open contour detected (scale factor: " + str(scaleFactor) + ")\n")
				scaleFactor *= 2
			elif ex.args[0] == "Contour self-intersection detected":
				stderr.write(glyph.glyphname + " contour self-intersection detected (scale factor: " + str(scaleFactor) + ")\n")
				scaleFactor *= 2
			else:
				raise
		else:
			break

def dumpGlyph(glyph):
	contours = []
	for contour in glyph.layers[1]:
		points = []
		for point in contour:
			points += [(point.x, point.y, point.on_curve)]
		contours += [tuple(points)]
	return tuple(contours)

def restoreGlyph(glyphDump):
	layer = fontforge.layer()
	for contourDump in glyphDump:
		contour = fontforge.contour()
		for pointDump in contourDump:
			contour += fontforge.point(pointDump[0], pointDump[1], pointDump[2])
		contour.closed = True
		layer += contour
	return layer

cache = shelve.open("_WORKDATA_" + splitext(argv[2])[0])
virginFound = False
font = fontforge.open(argv[1])
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		try:
			if glyph.glyphname not in cache:
				virginFound = True
				cache[glyph.glyphname] = 1; cache.sync()
				glyph.round()
				removeOverlaps(glyph)
				cache[glyph.glyphname] = dumpGlyph(glyph); cache.sync()
			elif isinstance(cache[glyph.glyphname], tuple):
				if virginFound:
					stderr.write("!!! Hash collision detected while processing " + glyph.glyphname + " !!!\nRemoving cache\n")
					del cache[glyph.glyphname]
					quit(5)
				glyph.layers[1] = restoreGlyph(cache[glyph.glyphname])
			elif cache[glyph.glyphname] == 1:
				virginFound = True
				stderr.write("Previous failure (glyph " + glyph.glyphname + ", code 1) detected\n")
				cache[glyph.glyphname] = 2; cache.sync()
				glyph.round()
				glyph.removeOverlap()
				cache[glyph.glyphname] = dumpGlyph(glyph); cache.sync()
			else:
				stderr.write("Previous failure (glyph " + glyph.glyphname + ", code " + str(cache[glyph.glyphname]) + ") detected!!\n")
				quit(1)
		except KeyboardInterrupt:
			stderr.write("Interrupt. Removing " + glyph.glyphname + " from cache\n")
			del cache[glyph.glyphname]
			quit(130)
#font.generate(argv[2])
font.save(argv[2])
font.close()
cache.close()
