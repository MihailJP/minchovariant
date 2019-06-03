#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/credits.rb"

(enName, enWeight) = ARGV
psName = "#{enName.gsub(/\s/, "")}-#{enWeight}"

print <<FINIS
FontName       (#{psName})
FullName       (#{enName} #{enWeight})
FamilyName     (#{enName})
Weight         (#{enWeight})
version        (#{fontVersion})
Registry       (Adobe)
Ordering       (Japan1)
Supplement     7
AdobeCopyright (#{fontCopyrightOf(enName).gsub(/\n/, " / ").gsub(/\s*\(.*?\)/, "")})
FINIS
