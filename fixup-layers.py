#!/usr/bin/env python

from sys import argv, stderr
import re

if len(argv) < 3:
	stderr.write("Usage: "+argv[0]+" infile outfile\n")
	quit(1)

# Workaround: make sure only the foreground layer exists
filetxt = ''; foretxt = None
with open(argv[1]) as sfd:
	with open(argv[2], 'w') as sfd2:
		for line in sfd.readlines():
			if re.match('StartChar:', line):
				sfd2.write(filetxt)
				filetxt = ''
			if re.match('Back', line):
				pass
			elif re.match('Fore', line):
				foretxt = line
				continue
			elif re.match('Comment', line):
				filetxt += line
			elif foretxt is None:
				filetxt += line
			else:
				filetxt += foretxt + line
			foretxt = None
		sfd2.write(filetxt)
