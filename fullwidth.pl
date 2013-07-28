#!/usr/bin/env perl

while (<>) {
	chomp;
	(my $flag, my $name, my $fw) = split(/\t/);
	$fw = "${name}-fullwidth" unless ($fw);
	if ($flag) {
		print "s/\\(^\\|:\\)${name}\\(\\s\\|\\\$\\|\$\\|:\\)/\\1${name}-halfwidth\\2/\n";
		print "/^${name}-halfwidth\\s/i ${name}\t99:0:0:0:0:200:200:${fw}\n";
	} else {
		print "/^${name}\\s/c ${name}\t99:0:0:0:0:200:200:${fw}\n";
	}
}
