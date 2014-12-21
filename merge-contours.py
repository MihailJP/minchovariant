#!/usr/bin/env fontforge

import fontforge, psMat
from sys import argv, stderr
from os.path import splitext
import shelve

fontforge.setPrefs('CoverageFormatsAllowed', 1)

CacheFileName = "_WORKDATA_" + splitext(argv[2])[0]
WatchdogFileName = "_WATCHDOG_" + splitext(argv[2])[0]

class WatchdogTimerWriter:
	def __init__(self, filename):
		self.fileName = filename
		self.lastUpdate = None
		self.remove()
	def remove(self):
		from os import unlink
		from sys import stderr
		import errno
		try:
			unlink(self.fileName)
		except OSError as e:
			if e.errno != errno.ENOENT:
				stderr.write(e.strerror + " (ignored)\n")
		self.lastUpdate = None
	def update(self):
		from os import utime
		from datetime import datetime
		from time import mktime
		currTime = int(mktime(datetime.utcnow().timetuple()))
		if self.lastUpdate is None or currTime > self.lastUpdate:
			with open(self.fileName, 'a'):
				utime(self.fileName, None)
			self.lastUpdate = currTime
	def __del__(self):
		self.remove()

class RedoIteration(Exception):
	pass

watchdog = WatchdogTimerWriter(WatchdogFileName)

def getContourPairs(layer):
	iterLayer = layer.dup()
	for i in range(0, len(iterLayer) - 1):
		for j in range(i + 1, len(iterLayer)):
			yield (iterLayer[i], iterLayer[j], i, j)

def writeStatus(text):
	stderr.write("\r" + (" " * 60) + "\r")
	stderr.write(text)
	stderr.flush()

def checkIfAllContoursClosed(layer):
	for contour in layer:
		if not contour.closed:
			return False
	return True

def checkNoClockwiseTriangle(layer):
	for contour in layer:
		if contour.isClockwise() == 1:
			count = 0
			for point in contour:
				if point.on_curve:
					count += 1
				else:
					break
			else:
				if count == 3:
					return False
	return True

def countClockwiseContours(layer):
	count = 0
	for contour in layer:
		if contour.isClockwise() == 1:
			count += 1
	return count

def mergeContours(layer, contour1, contour2):
	layer1 = fontforge.layer()
	layer2 = fontforge.layer()
	for contour in layer:
		if (contour == contour1) or (contour == contour2):
			layer1 += contour
		elif contour.isClockwise() == 0:
			layer1 += contour
		else:
			layer2 += contour
	layer3 = layer1.dup()
	layer3.correctDirection()
	if layer1 == layer3 and countClockwiseContours(layer3) == 2:
		layer1.removeOverlap()
		if (countClockwiseContours(layer1) == 1) and checkIfAllContoursClosed(layer1):
			layer1 += layer2
			return layer1
		else:
			return None
	else:
		return None

def mergeTwoContours(layer):
	tmpLayer = layer.dup()
	while True:
		workLayer = tmpLayer.dup()
		workLayer.transform(psMat.scale(4.0))
		try:
			for (contour1, contour2, contourNo1, contourNo2) in getContourPairs(workLayer):
				watchdog.update()
				if (contour1 is not contour2) and (contour1.isClockwise() == 1) and (contour2.isClockwise() == 1):
					newLayer = mergeContours(workLayer, contour1, contour2)
					if newLayer is not None:
						newLayer.transform(psMat.scale(0.25))
						tmpLayer = newLayer
						raise RedoIteration
		except RedoIteration:
			pass
		else:
			break
	return tmpLayer

def mergeContoursSimply(layer):
	for i in [4.0, 8.0, 16.0, 32.0]:
		watchdog.update()
		newLayer = layer.dup()
		newLayer.transform(psMat.scale(i))
		newLayer.removeOverlap()
		newLayer.transform(psMat.scale(1.0 / i))
		if checkIfAllContoursClosed(newLayer) and checkNoClockwiseTriangle(newLayer):
			return newLayer
	else:
		return None

def mergeContoursDistributed(layer, p):
	tmpLayer = layer.dup()
	for k in [4.0, 8.0, 16.0, 32.0]:
		workLayer = tmpLayer.dup()
		workLayer.transform(psMat.scale(k))
		layers = []
		for i in range(0, 2 ** p):
			layers += [fontforge.layer()]
		for i in range(0, len(workLayer)):
			layers[i % (2 ** p)] += workLayer[i]
		while len(layers) > 1:
			watchdog.update()
			for i in range(0, len(layers), 2):
				layers[i].removeOverlap()
				layers[i + 1].removeOverlap()
				layers[i] += layers[i + 1]
				layers[i + 1] = None
			layers = filter(lambda x: x is not None, layers)
		layers[0].removeOverlap()
		layers[0].transform(psMat.scale(1.0 / k))
		if checkIfAllContoursClosed(layers[0]) and checkNoClockwiseTriangle(layers[0]):
			return layers[0]
	else:
		return None

def removeOverlaps(glyph, cache, mode = 0):
	class BreakRequest(Exception):
		pass
	
	def simpleMerge(glyph):
		newLayer = mergeContoursSimply(glyph.layers[1])
		if newLayer is not None:
			glyph.layers[1] = newLayer
			raise BreakRequest
	def mergeWithDistributedSub(glyph, powerOfTwo):
		newLayer = mergeContoursDistributed(glyph.layers[1], powerOfTwo)
		if newLayer is not None:
			glyph.layers[1] = newLayer
			raise BreakRequest
	def roundedMergeWithDistributedSub(glyph, powerOfTwo): # round to 4x then merge
		tmpLayer = glyph.layers[1].dup()
		tmpLayer.transform(psMat.scale(0.25))
		tmpLayer.round()
		tmpLayer.transform(psMat.scale(4.0))
		newLayer = mergeContoursDistributed(tmpLayer, powerOfTwo)
		if newLayer is not None:
			glyph.layers[1] = newLayer
			raise BreakRequest
	def safeMerge(glyph): # slow but reliable
		tmpLayer = glyph.layers[1].dup()
		tmpLayer.transform(psMat.scale(0.25))
		tmpLayer.round()
		tmpLayer.transform(psMat.scale(4.0))
		newLayer = mergeTwoContours(tmpLayer)
		if newLayer is not None:
			glyph.layers[1] = newLayer
			raise BreakRequest
	
	Func = (
		(simpleMerge, None),
		(mergeWithDistributedSub, 1),
		(mergeWithDistributedSub, 2),
		(mergeWithDistributedSub, 3),
		(mergeWithDistributedSub, 4),
		(mergeWithDistributedSub, 5),
		(mergeWithDistributedSub, 6),
		(roundedMergeWithDistributedSub, 2),
		(roundedMergeWithDistributedSub, 3),
		(roundedMergeWithDistributedSub, 4),
		(roundedMergeWithDistributedSub, 5),
		(roundedMergeWithDistributedSub, 6),
		(safeMerge, None))
	
	writeStatus(glyph.glyphname)
	try:
		cacheFlag = False
		for (f, p) in Func[mode:]:
			if p is None:
				f(glyph)
			else:
				f(glyph, p)
			# Failure
			if cacheFlag:
				cache[glyph.glyphname] += 1; cache.sync()
			else:
				cacheFlag = True
	except BreakRequest:
		pass
	else:
		glyph.color = 0xff0000

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

cache = shelve.open(CacheFileName)
virginFound = False
font = fontforge.open(argv[1])
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		watchdog.update()
		while True:
			try:
				if glyph.glyphname not in cache:
					virginFound = True
					cache[glyph.glyphname] = 1; cache.sync()
					glyph.round()
					removeOverlaps(glyph, cache)
					cache[glyph.glyphname] = dumpGlyph(glyph); cache.sync()
				elif isinstance(cache[glyph.glyphname], tuple):
					if virginFound:
						stderr.write("!!! Hash collision detected while processing " + glyph.glyphname + " !!!\nRemoving cache\n")
						del cache[glyph.glyphname]
						quit(5)
					glyph.layers[1] = restoreGlyph(cache[glyph.glyphname])
				elif 1 <= cache[glyph.glyphname] <= 12:
					virginFound = True
					stderr.write("Previous failure (glyph " + glyph.glyphname + ", code " + str(cache[glyph.glyphname]) + ") detected\n")
					cache[glyph.glyphname] += 1; cache.sync()
					glyph.round()
					removeOverlaps(glyph, cache, cache[glyph.glyphname])
					cache[glyph.glyphname] = dumpGlyph(glyph); cache.sync()
				else:
					stderr.write("Previous failure (glyph " + glyph.glyphname + ", code " + str(cache[glyph.glyphname]) + ") detected!!\n")
					quit(1)
			except KeyboardInterrupt:
				stderr.write("Interrupt. Removing " + glyph.glyphname + " from cache\n")
				del cache[glyph.glyphname]
				quit(130)
			else:
				break
stderr.write("\rdone\r")
font.save(argv[2])
font.close()
