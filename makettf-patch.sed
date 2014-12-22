s/\/usr\/bin\/fontforge/env fontforge/
/^  &addglyph(\$code);/c \
  system("inkscape -z -a 0:0:200:200 -e $svgBaseName.png -w 1024 -h 1024 -d 1200 $svgBaseName.raw.svg") and die;\
  unlink "$svgBaseName.raw.svg";\
  system("convert $svgBaseName.png $svgBaseName.bmp") and die;\
  unlink "$svgBaseName.png";\
  system("potrace -s $svgBaseName.bmp -o $svgBaseName.svg") and die;\
  unlink "$svgBaseName.bmp";\
  my $refGlyph = $target;\
  if ($buhin{$target} =~ /^99:0:0:0:0:200:200:([\\w\\-]+)(?:\\:\\d+:\\d+:\\d+)?$/) {$refGlyph = $1;}\
  &addglyph($code, $refGlyph, $target);
/^Move(400, -400)/d
/^Move(0, 50)/d
/^RemoveOverlap()/d
/^SetWidth(1000)/i \
Scale(20)
/^Scale(500)/a \
CanonicalContours()\
CanonicalStart()\
FindIntersections()\
SetGlyphComment("Kage: $_[1]\\\\nAlias: $_[2]")
s/"Generate(\(.*\)\.ttf.*)/"Save(\1.sfd\\")/
/^foreach(sort(keys %buhin)){/,/^}/c \
open GLYPHLIST, "../glyphs.txt" or die "Cannot read the glyph list";\
while (<GLYPHLIST>) {\
	chomp; my $name = $_;\
	(my $target = $name) =~ s/^[uU]0*//g; # delete zero for the beginning\
	$target{$target} = $name;\
}\
close GLYPHLIST;
/^  while(\$buffer =~ m\/\\\$99/c \
  while($buffer =~ m/\\$99:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^\\$:]*)(?::[^\\$]*)?/gc){
/^sub addglyph/,/^}/ {
	/^  open/i \
{
	/^  open/ s/;/ or redo;/
	/^  close/a \
}
}
/\$WORKDIR\/build\/\$code/c \
  my $svgBaseName = "$WORKDIR/build/$code";\
  open FH, ">$svgBaseName.raw.svg";
