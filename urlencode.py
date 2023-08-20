#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, urllib.parse

sys.stdin.reconfigure(encoding='utf-8')

sys.stdout.write(urllib.parse.quote_plus(sys.stdin.read()))
