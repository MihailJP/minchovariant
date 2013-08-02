#!/usr/bin/env ruby

(enName, enWeight) = ARGV
license = 'Created by KAGE system. (http://fonts.jp/)'
psName = "#{enName.gsub(/\s/, "")}-#{enWeight}"

print <<FINIS
FontName       (#{psName})
FullName       (#{enName} #{enWeight})
FamilyName     (#{enName})
Weight         (#{enWeight})
version        (1.000)
Registry       (Adobe)
Ordering       (Japan1)
Supplement     6
AdobeCopyright (#{license})
FINIS
