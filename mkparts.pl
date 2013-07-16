#!/usr/bin/perl

while (<>) {
	chomp;
	my $currLine = $_;
	$rplFlag = (($rplLine = $currLine) =~ s/^ (\S+) *\| \S+ *\| (\S+) *$/$1\t$2/);
	$rplLine =~ s/\@\d+//g;
	my @rplLine = split(/\t/, $rplLine);
	$rplLine = join("\t", @rplLine);
	print $rplLine, "\n" if ($rplFlag);
}
