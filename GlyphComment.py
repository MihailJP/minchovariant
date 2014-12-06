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
