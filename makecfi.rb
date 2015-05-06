#!/usr/bin/env ruby

(enName, enWeight) = ARGV
license = 'Created by KAGE system. (http://fonts.jp/)'
psName = "#{enName.gsub(/\s/, "")}-#{enWeight}"

print <<FINIS
FontName       (#{psName})
FullName       (#{enName} #{enWeight})
FamilyName     (#{enName})
Weight         (#{enWeight})
version        (1.100)
Registry       (Adobe)
Ordering       (Japan1)
Supplement     6
AdobeCopyright (Japanese glyphs #{license} / Alphabet glyphs by Andrey V. Panov (C) 2005 All rights reserved.)
FINIS
