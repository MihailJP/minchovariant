#!/usr/bin/env fontforge

import fontforge, psMat
from re import search
from sys import argv, stderr
from math import atan2, degrees, hypot

class SpiroError(RuntimeError):
	pass

def analyzeAngles(contour):
	angles = []
	for i in range(0, len(contour)):
		angle = {}
		angle['anglePrev'] = degrees(atan2(contour[i-1].y - contour[i].y,
											contour[i-1].x - contour[i].x))
		angle['distPrev'] = hypot(contour[i-1].x - contour[i].x,
									contour[i-1].y - contour[i].y)
		angle['angleNext'] = degrees(atan2(contour[(i+1) % len(contour)].y - contour[i].y,
											contour[(i+1) % len(contour)].x - contour[i].x))
		angle['distNext'] = hypot(contour[(i+1) % len(contour)].x - contour[i].x,
									contour[(i+1) % len(contour)].y - contour[i].y)
		angle['vertex'] = (angle['anglePrev'] + angle['angleNext']) / 2
		angle['tangential'] = (angle['vertex'] + (90 if angle['anglePrev'] > angle['angleNext'] else 270)) % 360 - 180
		angle['angle'] = (angle['angleNext'] - angle['anglePrev'] + 180) % 360 - 180
		angles += [angle]
	return angles

def makeSpiro(contour, angles, obtusityLimit):
	spiros = []
	for i in range(0, len(contour)):
		point = contour[i]
		if abs(angles[i]['angle']) > obtusityLimit:
			spiros += [(point.x, point.y, fontforge.spiroG2, 0)]
		else:
			spiros += [(point.x, point.y, fontforge.spiroCorner, 0)]
	return spiros

def setSpiro(contour, spiros):
	origContour = contour.dup()
	contour.spiros = tuple(spiros)
	for point in contour:
		if point.x == 0 and point.y == 0:
			contour = origContour # Rollback
			raise SpiroError, "Point found at glyph origin"

if len(argv) < 3:
	stderr.write("Usage: "+argv[0]+" infile outfile\n")
	quit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

def getClockwiseContour(contour):
	if contour.isClockwise() == 0:
		newContour = fontforge.contour()
		for k in range(0, -len(contour), -1):
			newContour += contour[k]
		newContour.closed = True
		return newContour
	else:
		return contour.dup()

def separateSelfIntersections(contour):
	layer = fontforge.layer()
	for i in range(0, len(contour) - 1):
		for j in range(len(contour) - 1, i, -1):
			if contour[i] == contour[j] and contour[i].on_curve and contour[j].on_curve:
				c1 = fontforge.contour()
				c2 = fontforge.contour()
				c1 += contour[0:i]
				c1 += contour[j:len(contour)]
				c2 += contour[i:j]
				c1.closed = c2.closed = True
				try:
					c1 = getClockwiseContour(c1)
				except AttributeError:
					pass
				try:
					c2 = getClockwiseContour(c2)
				except AttributeError:
					pass
				layer += c1
				return layer + separateSelfIntersections(c2)
	if layer.isEmpty():
		layer += contour
	return layer

forceClockwiseFlag = (search('clockwise', argv[0]) is not None)

font = fontforge.open(argv[1])
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		layer = fontforge.layer()
		newLayer = fontforge.layer()
		for contour in glyph.layers[1]:
			if forceClockwiseFlag:
				layer += separateSelfIntersections(contour)
			else:
				layer += contour.dup()
		for origContour in layer:
			contour = getClockwiseContour(origContour) if forceClockwiseFlag else origContour.dup()
			newContour = contour.dup()
			angles = analyzeAngles(contour)
			obtusityLimit = 135 if len(contour) == 5 else 150
			try:
				spiros = makeSpiro(contour, angles, obtusityLimit)
				setSpiro(newContour, spiros)
			except SpiroError:
				newContour = contour.dup()
				newContour.simplify(10, ("smoothcurves",), 10, 30, 50)
			newLayer += newContour
		glyph.layers[1] = newLayer
		glyph.simplify()
font.save(argv[2])
font.close()

