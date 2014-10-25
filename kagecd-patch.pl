my $urokoOcc = 0;
my $urokoL = 0;
my $a14Occ = 0;
my $a14L = 0;
my $hosomiOcc = 0;
my $a22Flag = 0;
my $cr = '';
while (<>) {
	$cr = "\r" if (/\r$/);
	++$urokoL; ++$a14L;
	if (/\/\/UROKO/) {
		++$urokoOcc;
		$urokoL = 0;
		print;
	} elsif (($urokoOcc == 1 or $urokoOcc == 2) and $urokoL == 1) {
		print;
		print "          var urokoScale = (kage.kMinWidthU / kage.kMinWidthY - 1.0) / 4.0 + 1.0;$cr";
	} elsif ($urokoOcc == 1 and $urokoL == 4) {
		print "          poly.push(x2 - kage.kAdjustUrokoX[opt2] * urokoScale, y2);$cr";
	} elsif ($urokoOcc == 1 and $urokoL == 5) {
		print "          poly.push(x2 - kage.kAdjustUrokoX[opt2] * urokoScale / 2, y2 - kage.kAdjustUrokoY[opt2] * urokoScale);$cr";
	} elsif ($urokoOcc == 2 and $urokoL == 4) {
		print "          poly.push(x2 - Math.cos(rad) * kage.kAdjustUrokoX[opt2] * urokoScale, y2 - Math.sin(rad) * kage.kAdjustUrokoX[opt2] * urokoScale);$cr";
	} elsif ($urokoOcc == 2 and $urokoL == 5) {
		print "          poly.push(x2 - Math.cos(rad) * kage.kAdjustUrokoX[opt2] * urokoScale / 2 + Math.sin(rad) * kage.kAdjustUrokoX[opt2] * urokoScale / 2, y2 - Math.sin(rad) * kage.kAdjustUrokoY[opt2] * urokoScale - Math.cos(rad) * kage.kAdjustUrokoY[opt2] * urokoScale);$cr";
	} elsif (/if\(a2 == 14\)/) {
		++$a14Occ;
		$a14L = 0;
		print;
	} elsif ($a14Occ == 1 and $a14L == 4) {
		print "      var jumpFactor = (kMinWidthT > 6 ? 6.0 / kMinWidthT : 1.0);$cr";
		print "      poly.push(x2 - kage.kWidth * 4 * Math.min(1 - opt2 / 10, Math.pow(kMinWidthT / kage.kMinWidthT, 3)) * jumpFactor, y2 - kMinWidthT);$cr";
	} elsif ($a14Occ == 1 and $a14L == 5) {
		print "      poly.push(x2 - kage.kWidth * 4 * Math.min(1 - opt2 / 10, Math.pow(kMinWidthT / kage.kMinWidthT, 3)) * jumpFactor, y2 - kMinWidthT * 0.5);$cr";
	} elsif (/hosomi = 0.5;/ and $hosomiOcc == 0) {
		++$hosomiOcc;
		print "    var cornerOffset = 0;$cr";
		print "    function hypot() {return Math.sqrt(arguments[0] * arguments[0] + arguments[1] * arguments[1]);}$cr";
		print "    var contourLength = hypot(sx1-x1, sy1-y1) + hypot(sx2-sx1, sy2-sy1) + hypot(x2-sx2, y2-sy2);$cr";
		print "    if(a1 == 22 && a2 == 7 && contourLength < 100){$cr";
		print "        cornerOffset = (kMinWidthT > 6) ? (kMinWidthT - 6) * ((100 - contourLength) / 100) : 0;$cr";
		print "        x1 += cornerOffset;$cr";
		print "    }$cr";
		print "    $cr";
		print;
	} elsif (/if\(a1 == 22\)\{ \/\/box's up-right corner/ and $a22Flag == 0) {
		$a22Flag = 1;
		print;
	} elsif (/\}/ and $a22Flag == 1) {
		$a22Flag = 2;
		print;
	} elsif ($a22Flag == 1) {
		s/x1/x1 - cornerOffset/;
		print;
	} else {
		print;
	}
}
