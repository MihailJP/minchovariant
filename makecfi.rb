#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/credits.rb"

(enName, enWeight) = ARGV
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
AdobeCopyright (#{fontCopyrightOf(enName).gsub(/\n/, " / ").gsub(/\s*\(.*?\)/, "")})
FINIS
