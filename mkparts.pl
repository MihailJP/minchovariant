#!/usr/bin/perl

while (<>) {
	my $currLine = $_;
	$rplFlag = (($rplLine = $currLine) =~ s/^ (\S+) *\| \S+ *\| (\S+) *$/$1\t$2/);
	print $rplLine if ($rplFlag);
}
