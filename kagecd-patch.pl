my $urokoOcc = 0;
my $urokoL = 0;
my $a14Occ = 0;
my $a14L = 0;
my $hosomiOcc = 0;
my $a22Flag = 0;
my $gothicFontOcc = 0;
while (<>) {
	s/\r//g;
	++$urokoL; ++$a14L;
	if (/\/\/UROKO/) {
		++$urokoOcc;
		$urokoL = 0;
		print;
	} elsif (($urokoOcc == 1 or $urokoOcc == 2) and $urokoL == 1) {
		print;
		print "          var urokoScale = (kage.kMinWidthU / kage.kMinWidthY - 1.0) / 4.0 + 1.0;";
	} elsif ($urokoOcc == 1 and $urokoL == 4) {
		print "          poly.push(x2 - kage.kAdjustUrokoX[opt2] * urokoScale, y2);";
	} elsif ($urokoOcc == 1 and $urokoL == 5) {
		print "          poly.push(x2 - kage.kAdjustUrokoX[opt2] * urokoScale / 2, y2 - kage.kAdjustUrokoY[opt2] * urokoScale);";
	} elsif ($urokoOcc == 2 and $urokoL == 4) {
		print "          poly.push(x2 - Math.cos(rad) * kage.kAdjustUrokoX[opt2] * urokoScale, y2 - Math.sin(rad) * kage.kAdjustUrokoX[opt2] * urokoScale);";
	} elsif ($urokoOcc == 2 and $urokoL == 5) {
		print "          poly.push(x2 - Math.cos(rad) * kage.kAdjustUrokoX[opt2] * urokoScale / 2 + Math.sin(rad) * kage.kAdjustUrokoX[opt2] * urokoScale / 2, y2 - Math.sin(rad) * kage.kAdjustUrokoY[opt2] * urokoScale - Math.cos(rad) * kage.kAdjustUrokoY[opt2] * urokoScale);";
	} elsif (/if\(a2 == 14\)/) {
		++$a14Occ;
		$a14L = 0;
		print;
	} elsif ($a14Occ == 1 and $a14L == 4) {
		print "      var jumpFactor = (kMinWidthT > 6 ? 6.0 / kMinWidthT : 1.0);";
		print "      poly.push(x2 - kage.kWidth * 4 * Math.min(1 - opt2 / 10, Math.pow(kMinWidthT / kage.kMinWidthT, 3)) * jumpFactor, y2 - kMinWidthT);";
	} elsif ($a14Occ == 1 and $a14L == 5) {
		print "      poly.push(x2 - kage.kWidth * 4 * Math.min(1 - opt2 / 10, Math.pow(kMinWidthT / kage.kMinWidthT, 3)) * jumpFactor, y2 - kMinWidthT * 0.5);";
	} elsif (/hosomi = 0.5;/ and $hosomiOcc == 0) {
		++$hosomiOcc;
		print "    var cornerOffset = 0;";
		print "    function hypot() {return Math.sqrt(arguments[0] * arguments[0] + arguments[1] * arguments[1]);}";
		print "    var contourLength = hypot(sx1-x1, sy1-y1) + hypot(sx2-sx1, sy2-sy1) + hypot(x2-sx2, y2-sy2);";
		print "    if(a1 == 22 && a2 == 7 && contourLength < 100){";
		print "        cornerOffset = (kMinWidthT > 6) ? (kMinWidthT - 6) * ((100 - contourLength) / 100) : 0;";
		print "        x1 += cornerOffset;";
		print "    }";
		print "    ";
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
	} elsif (/\/\/gothic/ and $gothicFontOcc == 0) {
		$gothicFontOcc = 1;
		print <<FINIS;
  else if(kage.kShotai == kage.kSocho){ //socho
    a1 = ta1 % 1000;
    a2 = ta2 % 100;
    opt1 = Math.floor((ta1 % 10000) / 1000);
    opt2 = Math.floor((ta2 % 1000) / 100);
    opt3 = Math.floor((ta1 % 1000000) / 10000);
    opt4 = Math.floor(ta2 / 1000);
    var opt5 = Math.floor(ta1 / 1000000);
    
    kMinWidthT = kage.kMinWidthT - opt1 / 2;
    kMinWidthT2 = kage.kMinWidthT - opt4 / 2;
    
    switch(a1 % 100){
    case 0:
    case 7:
    case 27:
      delta = -1 * kage.kMinWidthY * 0.5;
      break;
    case 1:
    case 2: // ... must be 32
    case 6:
    case 22:
    case 32: // changed
      delta = 0;
      break;
    case 12:
    //case 32:
      delta = kage.kMinWidthY;
      break;
    default:
      break;
    }
    
    if(x1 == sx1){
      if(y1 < sy1){ y1 = y1 - delta; }
      else{ y1 = y1 + delta; }
    }
    else if(y1 == sy1){
      if(x1 < sx1){ x1 = x1 - delta; }
      else{ x1 = x1 + delta; }
    }
    else{
      rad = Math.atan((sy1 - y1) / (sx1 - x1));
      if(x1 < sx1){ v = 1; } else{ v = -1; }
      x1 = x1 - delta * Math.cos(rad) * v;
      y1 = y1 - delta * Math.sin(rad) * v;
    }
    
    switch(a2 % 100){
    case 0:
    case 1:
    case 7:
    case 9:
    case 15: // it can change to 15->5
    case 14: // it can change to 14->4
    case 17: // no need
    case 5:
      delta = 0;
      break;
    case 8: // get shorten for tail's circle
      delta = -1 * kMinWidthT * 0.5;
      break;
    default:
      break;
    }
    
    if(sx2 == x2){
      if(sy2 < y2){ y2 = y2 + delta; }
      else{ y2 = y2 - delta; }
    }
    else if(sy2 == y2){
      if(sx2 < x2){ x2 = x2 + delta; }
      else{ x2 = x2 - delta; }
    }
    else{
      rad = Math.atan((y2 - sy2) / (x2 - sx2));
      if(sx2 < x2){ v = 1; } else{ v = -1; }
      x2 = x2 + delta * Math.cos(rad) * v;
      y2 = y2 + delta * Math.sin(rad) * v;
    }
    
    var cornerOffset = 0;
    function hypot() {return Math.sqrt(arguments[0] * arguments[0] + arguments[1] * arguments[1]);}
    var contourLength = hypot(sx1-x1, sy1-y1) + hypot(sx2-sx1, sy2-sy1) + hypot(x2-sx2, y2-sy2);
    if((a1 == 22 || a1 == 27) && a2 == 7 && contourLength < 100){
        cornerOffset = (kMinWidthT > 6) ? (kMinWidthT - 6) * ((100 - contourLength) / 100) : 0;
        x1 += cornerOffset;
    }
    
    hosomi = 0.5;
    if(Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)) < 50){
      hosomi += 0.4 * (1 - Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)) / 50);
    }
    
    //---------------------------------------------------------------
    
    poly = new Polygon();
    poly2 = new Polygon();
    
    if (a2 != 14) {
    if(sx1 == sx2 && sy1 == sy2){ // Spline
      if(kage.kUseCurve){
        // generating fatten curve -- begin
        var kage2 = new Kage();
        kage2.kMinWidthY = kage.kMinWidthY;
        kage2.kMinWidthT = kMinWidthT;
        kage2.kWidth = kage.kWidth;
        kage2.kKakato = kage.kKakato;
        kage2.kRate = 10;
        
        var curve = new Array(2); // L and R
        get_candidate(kage2, curve, a1, a2, x1, y1, sx1, sy1, x2, y2, opt3, opt4);
        
        var dcl12_34 = new Array(2);
        var dcr12_34 = new Array(2);
        var dpl12_34 = new Array(2);
        var dpr12_34 = new Array(2);
        divide_curve(kage2, x1, y1, sx1, sy1, x2, y2, curve[0], dcl12_34, dpl12_34);
        divide_curve(kage2, x1, y1, sx1, sy1, x2, y2, curve[1], dcr12_34, dpr12_34);
        
        var ncl1 = new Array(7);
        var ncl2 = new Array(7);
        find_offcurve(kage2, dcl12_34[0], dpl12_34[0][2], dpl12_34[0][3], ncl1);
        find_offcurve(kage2, dcl12_34[1], dpl12_34[1][2], dpl12_34[1][3], ncl2);
        
        poly.push(ncl1[0], ncl1[1]);
        poly.push(ncl1[2], ncl1[3], 1);
        poly.push(ncl1[4], ncl1[5]);
        poly.push(ncl2[2], ncl2[3], 1);
        poly.push(ncl2[4], ncl2[5]);
        
        poly2.push(dcr12_34[0][0][0], dcr12_34[0][0][1]);
        poly2.push(dpr12_34[0][2] - (ncl1[2] - dpl12_34[0][2]), dpl12_34[0][3] - (ncl1[3] - dpl12_34[0][3]), 1);
        poly2.push(dcr12_34[0][dcr12_34[0].length - 1][0], dcr12_34[0][dcr12_34[0].length - 1][1]);
        poly2.push(dpr12_34[1][2] - (ncl2[2] - dpl12_34[1][2]), dpl12_34[1][3] - (ncl2[3] - dpl12_34[1][3]), 1);
        poly2.push(dcr12_34[1][dcr12_34[1].length - 1][0], dcr12_34[1][dcr12_34[1].length - 1][1]);
        
        poly2.reverse();
        poly.concat(poly2);
        polygons.push(poly);
        // generating fatten curve -- end
      } else {
        for(tt = 0; tt <= 1000; tt = tt + kage.kRate){
          var x1a = x1; var y1a = y1;
          var sx1a = sx1; var sy1a = sy1;
          var sx2a = sx2; var sy2a = sy2;
          var x2a = x2; var y2a = y2;
          if ((a1 == 7 || a1 == 27) && a2 == 0 && (sy2a < y2a)) {//L2RD-HARAI
            sx1a = (sx1 - x1) / x2 * (x2 + kMinWidthT) + x1;
            sy1a = (sy1 - y1) / y2 * (y2 + kMinWidthT * 2) + y1;
            sx2a = (sx2 - x1) / x2 * (x2 + kMinWidthT) + x1;
            sy2a = (sy2 - y1) / y2 * (y2 + kMinWidthT * 2) + y1;
            x2a = x2 + kMinWidthT * 2; y2a = y2 + kMinWidthT * 2;
          }
          
          t = tt / 1000;
          
          // calculate a dot
          x = ((1.0 - t) * (1.0 - t) * x1a + 2.0 * t * (1.0 - t) * sx1a + t * t * x2a);
          y = ((1.0 - t) * (1.0 - t) * y1a + 2.0 * t * (1.0 - t) * sy1a + t * t * y2a);
          
          // KATAMUKI of vector by BIBUN
          ix = (x1a - 2.0 * sx1a + x2a) * 2.0 * t + (-2.0 * x1a + 2.0 * sx1a);
          iy = (y1a - 2.0 * sy1a + y2a) * 2.0 * t + (-2.0 * y1a + 2.0 * sy1a);
          
          // line SUICHOKU by vector
          if(ix != 0 && iy != 0){
            ir = Math.atan(iy / ix * -1);
            ia = Math.sin(ir) * (kMinWidthT);
            ib = Math.cos(ir) * (kMinWidthT);
          }
          else if(ix == 0){
            ia = kMinWidthT;
            ib = 0;
          }
          else{
            ia = 0;
            ib = kMinWidthT;
          }
          
          if((a1 == 7 || a1 == 27) && a2 == 0){ // L2RD: fatten
            deltad = Math.pow(t, hosomi) * kage.kL2RDfatten;
          }
          else if(a1 == 7 || a1 == 27){
            deltad = Math.pow(t, hosomi);
          }
          else if(a2 == 7){
            deltad = Math.pow(1.0 - t, hosomi);
          }
          else if(opt3 > 0 || opt4 > 0){
              deltad = ((kage.kMinWidthT - opt3 / 2) - (opt4 - opt3) / 2 * t) / kage.kMinWidthT;
          }
          else{ deltad = 1; }
          
          if(deltad < 0.15){
            deltad = 0.15;
          }
          ia = ia * deltad;
          ib = ib * deltad;
          
          //reverse if vector is going 2nd/3rd quadrants
          if(ix <= 0){
            ia = ia * -1;
            ib = ib * -1;
          }
          
          //copy to polygon structure
          poly.push(x - ia, y - ib);
          if ((a1 == 7 || a1 == 27) && a2 == 0 && (sy2a < y2a) && (y + ib > y2a)) {//L2RD-HARAI
            //poly2.push(x + ia, y2a);
          }else if ((a1 == 7 || a1 == 27) && a2 == 0 && (sy2a < y2a)) {//L2RD-HARAI
            poly2.push(x + ia - kMinWidthT * 2 * t * t * t, y + ib);
          }else{
            poly2.push(x + ia, y + ib);
          }
        }
        
        // suiheisen ni setsuzoku
        if(a1 == 132){
          var index = 0;
          while(true){
            if(poly2.array[index].y <= y1 && y1 <= poly2.array[index + 1].y){
              break;
            }
            index++;
          }
          newx1 = poly2.array[index + 1].x + (poly2.array[index].x - poly2.array[index + 1].x) *
            (poly2.array[index + 1].y - y1) / (poly2.array[index + 1].y - poly2.array[index].y);
          newy1 = y1;
          newx2 = poly.array[0].x + (poly.array[0].x - poly.array[1].x) * (poly.array[0].y - y1) /
            (poly.array[1].y - poly.array[0].y);
          newy2 = y1;
          
          for(var i = 0; i < index; i++){
            poly2.shift();
          }
          poly2.set(0, newx1, newy1);
          poly.unshift(newx2, newy2);
        }
        
        // suiheisen ni setsuzoku 2
        if(a1 == 22 && y1 > y2){
          var index = 0;
          while(true){
            if(poly2.array[index].y <= y1 && y1 <= poly2.array[index + 1].y){
              break;
            }
            index++;
          }
          newx1 = poly2.array[index + 1].x + (poly2.array[index].x - poly2.array[index + 1].x) *
            (poly2.array[index + 1].y - y1) / (poly2.array[index + 1].y - poly2.array[index].y);
          newy1 = y1;
          newx2 = poly.array[0].x + (poly.array[0].x - poly.array[1].x - 1) * (poly.array[0].y - y1) /
            (poly.array[1].y - poly.array[0].y);
          newy2 = y1 + 1;
          
          for(var i = 0; i < index; i++){
            poly2.shift();
          }
          poly2.set(0, newx1, newy1);
          poly.unshift(newx2, newy2);
        }
        
        poly2.reverse();
        poly.concat(poly2);
        polygons.push(poly);
      }
    } else { // Bezier
      for(tt = 0; tt <= 1000; tt = tt + kage.kRate){
        var x1a = x1; var y1a = y1;
        var sx1a = sx1; var sy1a = sy1;
        var sx2a = sx2; var sy2a = sy2;
        var x2a = x2; var y2a = y2;
        if ((a1 == 7 || a1 == 27) && a2 == 0 && (sy2a < y2a)) {//L2RD-HARAI
          sx1a = (sx1 - x1) / x2 * (x2 + kMinWidthT) + x1;
          sy1a = (sy1 - y1) / y2 * (y2 + kMinWidthT * 2) + y1;
          sx2a = (sx2 - x1) / x2 * (x2 + kMinWidthT) + x1;
          sy2a = (sy2 - y1) / y2 * (y2 + kMinWidthT * 2) + y1;
          x2a = x2 + kMinWidthT * 2; y2a = y2 + kMinWidthT * 2;
        }
          
        t = tt / 1000;
        
        // calculate a dot
        x = (1.0 - t) * (1.0 - t) * (1.0 - t) * x1a + 3.0 * t * (1.0 - t) * (1.0 - t) * sx1a + 3 * t * t * (1.0 - t) * sx2a + t * t * t * x2a;
        y = (1.0 - t) * (1.0 - t) * (1.0 - t) * y1a + 3.0 * t * (1.0 - t) * (1.0 - t) * sy1a + 3 * t * t * (1.0 - t) * sy2a + t * t * t * y2a;
        // KATAMUKI of vector by BIBUN
        ix = t * t * (-3 * x1a + 9 * sx1a + -9 * sx2a + 3 * x2a) + t * (6 * x1a + -12 * sx1a + 6 * sx2a) + -3 * x1a + 3 * sx1a;
        iy = t * t * (-3 * y1a + 9 * sy1a + -9 * sy2a + 3 * y2a) + t * (6 * y1a + -12 * sy1a + 6 * sy2a) + -3 * y1a + 3 * sy1a;
        
        // line SUICHOKU by vector
        if(ix != 0 && iy != 0){
          ir = Math.atan(iy / ix * -1);
          ia = Math.sin(ir) * (kMinWidthT);
          ib = Math.cos(ir) * (kMinWidthT);
        }
        else if(ix == 0){
          ia = kMinWidthT;
          ib = 0;
        }
        else{
          ia = 0;
          ib = kMinWidthT;
        }
        
        if((a1 == 7 || a1 == 27) && a2 == 0){ // L2RD: fatten
          deltad = Math.pow(t, hosomi) * kage.kL2RDfatten;
        }
        else if(a1 == 7 || a1 == 27){
          deltad = Math.pow(t, hosomi);
          deltad = Math.pow(deltad, 0.7); // make fatten
        }
        else if(a2 == 7){
          deltad = Math.pow(1.0 - t, hosomi);
        }
        else{ deltad = 1; }
        
        if(deltad < 0.15){
          deltad = 0.15;
        }
        ia = ia * deltad;
        ib = ib * deltad;
        
        //reverse if vector is going 2nd/3rd quadrants
        if(ix <= 0){
          ia = ia * -1;
          ib = ib * -1;
        }
        
        //copy to polygon structure
        poly.push(x - ia, y - ib);
        if ((a1 == 7 || a1 == 27) && a2 == 0 && (sy2a < y2a) && (y + ib > y2a)) {//L2RD-HARAI
          //poly2.push(x + ia, y2a);
        }else if ((a1 == 7 || a1 == 27) && a2 == 0 && (sy2a < y2a)) {//L2RD-HARAI
          poly2.push(x + ia - kMinWidthT * 2 * t * t * t, y + ib);
        }else{
          poly2.push(x + ia, y + ib);
        }
      }
      
      // suiheisen ni setsuzoku
      if(a1 == 132){
        var index = 0;
        while(true){
          if(poly2.array[index].y <= y1 && y1 <= poly2.array[index + 1].y){
            break;
          }
          index++;
        }
        newx1 = poly2.array[index + 1].x + (poly2.array[index].x - poly2.array[index + 1].x) *
          (poly2.array[index + 1].y - y1) / (poly2.array[index + 1].y - poly2.array[index].y);
        newy1 = y1;
        newx2 = poly.array[0].x + (poly.array[0].x - poly.array[1].x) * (poly.array[0].y - y1) /
          (poly.array[1].y - poly.array[0].y);
        newy2 = y1;
        
        for(var i = 0; i < index; i++){
          poly2.shift();
        }
        poly2.set(0, newx1, newy1);
        poly.unshift(newx2, newy2);
      }
      
      // suiheisen ni setsuzoku 2
      if(a1 == 22){
        var index = 0;
        while(true){
          if(poly2.array[index].y <= y1 && y1 <= poly2.array[index + 1].y){
            break;
          }
          index++;
        }
        newx1 = poly2.array[index + 1].x + (poly2.array[index].x - poly2.array[index + 1].x) *
          (poly2.array[index + 1].y - y1) / (poly2.array[index + 1].y - poly2.array[index].y);
        newy1 = y1;
        newx2 = poly.array[0].x + (poly.array[0].x - poly.array[1].x - 1) * (poly.array[0].y - y1) /
          (poly.array[1].y - poly.array[0].y);
        newy2 = y1 + 1;
        
        for(var i = 0; i < index; i++){
          poly2.shift();
        }
        poly2.set(0, newx1, newy1);
        poly.unshift(newx2, newy2);
      }
      
      poly2.reverse();
      poly.concat(poly2);
      polygons.push(poly);
    }
    }
    
    //process for head of stroke
    rad = Math.atan((sy1 - y1) / (sx1 - x1));
    if(x1 < sx1){ v = 1; } else{ v = -1; }
    XX = Math.sin(rad) * v;
    XY = Math.cos(rad) * v * -1;
    YX = Math.cos(rad) * v;
    YY = Math.sin(rad) * v;
    
    if(a1 == 12){
      if(x1 == x2){
        poly= new Polygon();
        poly.push(x1 - kMinWidthT, y1);
        poly.push(x1 + kMinWidthT, y1);
        poly.push(x1 - kMinWidthT, y1 - kMinWidthT);
        polygons.push(poly);
      }
      else{
        poly = new Polygon();
        poly.push(x1 - kMinWidthT * XX, y1 - kMinWidthT * XY);
        poly.push(x1 + kMinWidthT * XX, y1 + kMinWidthT * XY);
        poly.push(x1 - kMinWidthT * XX - kMinWidthT * YX, y1 - kMinWidthT * XY - kMinWidthT * YY);
        polygons.push(poly);
      }
    }
    
    var type;
    var pm = 0;
    if(a1 == 0){
      if(y1 <= y2){ //from up to bottom
        type = (Math.atan2(Math.abs(y1 - sy1), Math.abs(x1 - sx1)) / Math.PI * 2 - 0.4);
        if(type > 0){
          type = type * 2;
        } else {
          type = type * 16;
        }
        if(type < 0){
          pm = -1;
        } else {
          pm = 1;
        }
      }
    }
    
    if(a1 == 22 || a1 == 27){ //box's up-right corner, any time same degree
      poly = new Polygon();
      poly.push(x1 - cornerOffset - kMinWidthT, y1 - kage.kMinWidthY);
      poly.push(x1 - cornerOffset, y1 - kage.kMinWidthY - kage.kWidth);
      poly.push(x1 - cornerOffset + kMinWidthT + kage.kWidth, y1 + kage.kMinWidthY);
      poly.push(x1 - cornerOffset + kMinWidthT, y1 + kMinWidthT - 1);
      if (a1 == 27) {
        poly.push(x1 - cornerOffset, y1 + kMinWidthT + 2);
        poly.push(x1 - cornerOffset, y1);
      } else {
        poly.push(x1 - cornerOffset - kMinWidthT, y1 + kMinWidthT + 4);
      }
      polygons.push(poly);
    }
    
    if(a1 == 0){ //beginning of the stroke
      if(y1 <= y2){ //from up to bottom
        if(pm > 0){
          type = 0;
        }
        var move = kage.kMinWidthY * type * pm;
        if(x1 == sx1){
          poly = new Polygon();
          if (opt5 > 0) {
            poly.push(x1 - kMinWidthT * 1.5,             y1);
            poly.push(x1,                                y1 + kMinWidthT / 2);
            poly.push(x1 + kMinWidthT,                   y1 + kMinWidthT);
          } else {
            poly.push(x1 - kMinWidthT * 1.5,             y1 - kMinWidthT);
            poly.push(x1,                                y1 - kMinWidthT / 2);
            poly.push(x1 + kMinWidthT + kage.kMinWidthY, y1);
          }
          poly.push(  x1 + kMinWidthT,                   y1 + kage.kMinWidthY * 3);
          poly.push(  x1,                                y1 + kage.kMinWidthY * 8);
          polygons.push(poly);
        }
        else{
          poly = new Polygon();
          var baseDirection = x1 > sx1 ? rad + (Math.PI) / 2 : rad - (Math.PI) / 2;
          var angleOffset = x1 > sx1 ? kMinWidthT * Math.abs(baseDirection) : 0;
          if (opt5 > 0) {
            pushRotated(poly, baseDirection, x1, y1, - kMinWidthT * 1.5,             0);
            pushRotated(poly, baseDirection, x1, y1, 0,                              + kMinWidthT / 2);
            pushRotated(poly, baseDirection, x1, y1, + kMinWidthT,                   + kMinWidthT);
          } else {
            pushRotated(poly, baseDirection, x1, y1, - kMinWidthT * 1.5,             - kMinWidthT);
            pushRotated(poly, baseDirection, x1, y1, 0,                              - kMinWidthT / 2 - angleOffset / 2);
            pushRotated(poly, baseDirection, x1, y1, + kMinWidthT + kage.kMinWidthY,                  - angleOffset);
          }
          pushRotated(  poly, baseDirection, x1, y1, + kMinWidthT,                   + kage.kMinWidthY * 3);
          pushRotated(  poly, baseDirection, x1, y1, 0,                              + kage.kMinWidthY * 8);
          //if(x1 < x2){
          //  poly.reverse();
          //}
          polygons.push(poly);
        }
      }
      else{ //from bottom to up
        var pLength = Math.sqrt((sx1 - x1) * (sx1 - x1) + (sy1 - y1) * (sy1 - y1));
        var wedgeFact = (pLength > kage.kMinWidthY * 16) ? 1.0 : pLength / (kage.kMinWidthY * 16);
        if(x1 == sx1){
          poly = new Polygon();
          poly.push(x1 + kMinWidthT * 1.5,             y1 - kMinWidthT);
          poly.push(x1,                                y1 - kMinWidthT / 2);
          poly.push(x1 - kMinWidthT - kage.kMinWidthY, y1);
          poly.push(x1 - kMinWidthT,                   y1 + kage.kMinWidthY * 3 * wedgeFact);
          poly.push(x1,                                y1 + kage.kMinWidthY * 8 * wedgeFact);
          polygons.push(poly);
        }
        else{
          poly = new Polygon();
          pushRotated(poly, rad - (Math.PI) / 2, x1, y1, + kMinWidthT * 1.5,             - kMinWidthT);
          pushRotated(poly, rad - (Math.PI) / 2, x1, y1, 0,                              - kMinWidthT / 2);
          pushRotated(poly, rad - (Math.PI) / 2, x1, y1, - kMinWidthT - kage.kMinWidthY, 0);
          pushRotated(poly, rad - (Math.PI) / 2, x1, y1, - kMinWidthT,                   + kage.kMinWidthY * 3 * wedgeFact);
          pushRotated(poly, rad - (Math.PI) / 2, x1, y1, 0,                              + kage.kMinWidthY * 8 * wedgeFact);
           //if(x1 < x2){
          //  poly.reverse();
          //}
          polygons.push(poly);
        }
      }
    }
    
    //process for tail
    rad = Math.atan((y2 - sy2) / (x2 - sx2));
    if(sx2 < x2){ v = 1; } else{ v = -1; }
    YX = Math.sin(rad) * v * -1;
    YY = Math.cos(rad) * v;
    XX = Math.cos(rad) * v;
    XY = Math.sin(rad) * v;
    
    if(a2 == 1 || a2 == 8 || a2 == 15){ //the last filled circle ... it can change 15->5
      if(sx2 == x2){
        poly = new Polygon();
        if(kage.kUseCurve){
          // by curve path
          poly.push(x2 - kMinWidthT2, y2);
          poly.push(x2 - kMinWidthT2 * 0.9, y2 + kMinWidthT2 * 0.9, 1);
          poly.push(x2, y2 + kMinWidthT2);
          poly.push(x2 + kMinWidthT2 * 0.9, y2 + kMinWidthT2 * 0.9, 1);
          poly.push(x2 + kMinWidthT2, y2);
        } else {
          // by polygon
          poly.push(x2 - kMinWidthT2, y2);
          poly.push(x2 - kMinWidthT2 * 0.7, y2 + kMinWidthT2 * 0.7);
          poly.push(x2, y2 + kMinWidthT2);
          poly.push(x2 + kMinWidthT2 * 0.7, y2 + kMinWidthT2 * 0.7);
          poly.push(x2 + kMinWidthT2, y2);
        }
        polygons.push(poly);
      }
      else if(sy2 == y2){
        poly = new Polygon();
        if(kage.kUseCurve){
          // by curve path
          poly.push(x2, y2 - kMinWidthT2);
          poly.push(x2 + kMinWidthT2 * 0.9, y2 - kMinWidthT2 * 0.9, 1);
          poly.push(x2 + kMinWidthT2, y2);
          poly.push(x2 + kMinWidthT2 * 0.9, y2 + kMinWidthT2 * 0.9, 1);
          poly.push(x2, y2 + kMinWidthT2);
        } else {
          // by polygon
          poly.push(x2, y2 - kMinWidthT2);
          poly.push(x2 + kMinWidthT2 * 0.7, y2 - kMinWidthT2 * 0.7);
          poly.push(x2 + kMinWidthT2, y2);
          poly.push(x2 + kMinWidthT2 * 0.7, y2 + kMinWidthT2 * 0.7);
          poly.push(x2, y2 + kMinWidthT2);
        }
        polygons.push(poly);
      }
      else{
        poly = new Polygon();
        if(kage.kUseCurve){
          poly.push(x2 + Math.sin(rad) * kMinWidthT2 * v, y2 - Math.cos(rad) * kMinWidthT2 * v);
          poly.push(x2 + Math.cos(rad) * kMinWidthT2 * 0.9 * v + Math.sin(rad) * kMinWidthT2 * 0.9 * v,
                    y2 + Math.sin(rad) * kMinWidthT2 * 0.9 * v - Math.cos(rad) * kMinWidthT2 * 0.9 * v, 1);
          poly.push(x2 + Math.cos(rad) * kMinWidthT2 * v, y2 + Math.sin(rad) * kMinWidthT2 * v);
          poly.push(x2 + Math.cos(rad) * kMinWidthT2 * 0.9 * v - Math.sin(rad) * kMinWidthT2 * 0.9 * v,
                    y2 + Math.sin(rad) * kMinWidthT2 * 0.9 * v + Math.cos(rad) * kMinWidthT2 * 0.9 * v, 1);
          poly.push(x2 - Math.sin(rad) * kMinWidthT2 * v, y2 + Math.cos(rad) * kMinWidthT2 * v);
        } else {
          poly.push(x2 + Math.sin(rad) * kMinWidthT2 * v, y2 - Math.cos(rad) * kMinWidthT2 * v);
          poly.push(x2 + Math.cos(rad) * kMinWidthT2 * 0.7 * v + Math.sin(rad) * kMinWidthT2 * 0.7 * v,
                    y2 + Math.sin(rad) * kMinWidthT2 * 0.7 * v - Math.cos(rad) * kMinWidthT2 * 0.7 * v);
          poly.push(x2 + Math.cos(rad) * kMinWidthT2 * v, y2 + Math.sin(rad) * kMinWidthT2 * v);
          poly.push(x2 + Math.cos(rad) * kMinWidthT2 * 0.7 * v - Math.sin(rad) * kMinWidthT2 * 0.7 * v,
                    y2 + Math.sin(rad) * kMinWidthT2 * 0.7 * v + Math.cos(rad) * kMinWidthT2 * 0.7 * v);
          poly.push(x2 - Math.sin(rad) * kMinWidthT2 * v, y2 + Math.cos(rad) * kMinWidthT2 * v);
        }
        polygons.push(poly);
      }
    }
    
    if(a2 == 9 || ((a1 == 7 || a1 == 27) && a2 == 0 && (sy2a >= y2a))){ // Math.sinnyu & L2RD Harai ... no need for a2=9
      var type = (Math.atan2(Math.abs(y2 - sy2), Math.abs(x2 - sx2)) / Math.PI * 2 - 0.6);
      if(type > 0){
        type = type * 8;
      } else {
        type = type * 3;
      }
      var pm = 0;
      if(type < 0){
        pm = -1;
      } else {
        pm = 1;
      }
      if(sy2 == y2){
        poly = new Polygon();
        poly.push(x2, y2 + kMinWidthT * kage.kL2RDfatten);
        poly.push(x2, y2 - kMinWidthT * kage.kL2RDfatten);
        poly.push(x2 + kMinWidthT * kage.kL2RDfatten * Math.abs(type), y2 + kMinWidthT * kage.kL2RDfatten * pm);
        polygons.push(poly);
      }
      else{
        poly = new Polygon();
        poly.push(x2 + kMinWidthT * kage.kL2RDfatten * YX, y2 + kMinWidthT * kage.kL2RDfatten * YY);
        poly.push(x2 - kMinWidthT * kage.kL2RDfatten * YX, y2 - kMinWidthT * kage.kL2RDfatten * YY);
        poly.push(x2 + kMinWidthT * kage.kL2RDfatten * Math.abs(type) * XX + kMinWidthT * kage.kL2RDfatten * pm * YX,
                  y2 + kMinWidthT * kage.kL2RDfatten * Math.abs(type) * XY + kMinWidthT * kage.kL2RDfatten * pm * YY);
        polygons.push(poly);
      }
    }
    
    if(a2 == 15){ //jump up ... it can change 15->5
      // anytime same degree
      poly = new Polygon();
      if(y1 < y2){
        poly.push(x2 + kMinWidthT, y2);
        poly.push(x2 + 2, y2 - kMinWidthT - kage.kWidth * 5);
        poly.push(x2, y2 - kMinWidthT - kage.kWidth * 5);
        poly.push(x2 - kMinWidthT, y2 - kMinWidthT + 1);
      } else {
        poly.push(x2 - kMinWidthT, y2);
        poly.push(x2 - 2, y2 + kMinWidthT + kage.kWidth * 5);
        poly.push(x2, y2 + kMinWidthT + kage.kWidth * 5);
        poly.push(x2 + kMinWidthT, y2 + kMinWidthT - 1);
      }
      polygons.push(poly);
    }
    
    if(a2 == 14){ //jump to left, allways go left
      poly = new Polygon();
      poly.push(x1, y2 + kMinWidthT);
      poly.push(x1, y2 - kMinWidthT);
      var jumpFactor = (kMinWidthT > 6 ? 6.0 / kMinWidthT : 1.0);
      poly.push(x2 - kage.kWidth * 4 * Math.min(1 - opt2 / 10, Math.pow(kMinWidthT / kage.kMinWidthT, 3)) * jumpFactor, y2 - kMinWidthT * 1.5 - 2);
      poly.push(x2 - kage.kWidth * 4 * Math.min(1 - opt2 / 10, Math.pow(kMinWidthT / kage.kMinWidthT, 3)) * jumpFactor, y2 - kMinWidthT * 1.5);
      //poly.reverse();
      polygons.push(poly);
    }
  }
FINIS
		print;
	} elsif (/\/\/gothic/ and $gothicFontOcc == 1) {
		$gothicFontOcc = 2;
		print <<FINIS;
  else if(kage.kShotai == kage.kSocho){ //socho
    x1 = tx1;
    y1 = ty1;
    x2 = tx2;
    y2 = ty2;
    a1 = ta1 % 1000;
    a2 = ta2 % 100;
    opt1 = Math.floor(ta1 / 1000) % 100;
    opt2 = Math.floor(ta2 / 100);
    var opt3 = Math.floor(ta1 / 100000);
    
    kMinWidthT = kage.kMinWidthT - opt1 / 2;
    
    if(x1 == x2){ //if TATE stroke, use y-axis
      poly = new Polygon(4);
      switch(a1){
      case 0:
        poly.set(3, x1 - kMinWidthT, y1 + kage.kMinWidthY * 0.5);
        poly.set(0, x1 + kMinWidthT, y1 + kage.kMinWidthY * 1.5);
        break;
      case 1:
      case 6: //... no need
      case 22:
        poly.set(3, x1 - kMinWidthT, y1);
        poly.set(0, x1 + kMinWidthT, y1);
        break;
      case 12:
        poly.set(3, x1 - kMinWidthT, y1 - kage.kMinWidthY);
        poly.set(0, x1 + kMinWidthT, y1);
        break;
      case 32:
        poly.set(3, x1 - kMinWidthT, y1 - kage.kMinWidthY);
        poly.set(0, x1 + kMinWidthT, y1 - kage.kMinWidthY);
        break;
      }
      
      switch(a2){
      case 0:
        if(a1 == 6){ //KAGI's tail ... no need
          poly.set(2, x2 - kMinWidthT, y2);
          poly.set(1, x2 + kMinWidthT, y2);
        }
        else{
          poly.set(2, x2 - kMinWidthT, y2 - kMinWidthT * 2);
          poly.set(1, x2 + kMinWidthT, y2);
        }
        break;
      case 1:
        poly.set(2, x2 - kMinWidthT, y2);
        poly.set(1, x2 + kMinWidthT, y2);
        break;
      case 13:
        poly.set(2, x2 - kMinWidthT, y2 + kage.kAdjustKakatoL[opt2] - kMinWidthT * 2);
        poly.set(1, x2 + kMinWidthT, y2 + kage.kAdjustKakatoL[opt2]);
        break;
      case 23:
        poly.set(2, x2 - kMinWidthT, y2 + kage.kAdjustKakatoR[opt2] - kMinWidthT * 2);
        poly.set(1, x2 + kMinWidthT, y2 + kage.kAdjustKakatoR[opt2]);
        break;
      case 32:
        poly.set(2, x2 - kMinWidthT, y2 + kage.kMinWidthY);
        poly.set(1, x2 + kMinWidthT, y2 + kage.kMinWidthY);
        break;
      }
      
      polygons.push(poly);
      
      if(a1 == 22 || a1 == 27){ //box's right top corner
        poly = new Polygon();
        poly.push(x1 - kMinWidthT, y1 - kage.kMinWidthY);
        poly.push(x1, y1 - kage.kMinWidthY - kage.kWidth);
        poly.push(x1 + kMinWidthT + kage.kWidth, y1 + kage.kMinWidthY);
        poly.push(x1 + kMinWidthT, y1 + kMinWidthT);
        poly.push(x1 - kMinWidthT, y1);
        polygons.push(poly);
      }
      
      if(a1 == 0 || a1 == 12){ //beginning of the stroke
        poly = new Polygon();
        if (opt3 > 0) {
          poly.push(x1 - kMinWidthT, y1 - kage.kMinWidthY * (a1 == 12 ? 1.5 : 2));
          poly.push(x1 - kMinWidthT / 2, y1 - kage.kMinWidthY * (a1 == 12 ? 2 : 2.5));
        } else {
          poly.push(x1 - kMinWidthT - kage.kMinWidthY, y1 - kage.kMinWidthY * (a1 == 12 ? 4 : 2.5));
          poly.push(x1 - kMinWidthT - kage.kMinWidthY, y1 - kage.kMinWidthY * (a1 == 12 ? 4.5 : 3));
        }
        poly.push(x1, y1 - kage.kMinWidthY * (a1 == 12 ? 1.5 : 0));
        poly.push(x1 + kMinWidthT, y1 + kage.kMinWidthY * (a1 == 12 ? 0 : 1.5));
        poly.push(x1 + kMinWidthT + kMinWidthT * 0.5, y1 + kage.kMinWidthY * (a1 == 12 ? 1 : 2.5));
        poly.push(x1 + kMinWidthT - 2, y1 + kage.kMinWidthY * (a1 == 12 ? 2 : 3.5) + 1);
        poly.push(x1 - kMinWidthT, y1 + kage.kMinWidthY * (a1 == 12 ? -0.5 : 1));
        polygons.push(poly);
      }
      
      if((a1 == 6 && a2 == 0) || a2 == 1){ //KAGI NO YOKO BOU NO SAIGO NO MARU ... no need only used at 1st=yoko
        poly = new Polygon();
        if(kage.kUseCurve){
          poly.push(x2 - kMinWidthT, y2);
          poly.push(x2 - kMinWidthT * 0.9, y2 + kMinWidthT * 0.9, 1);
          poly.push(x2, y2 + kMinWidthT);
          poly.push(x2 + kMinWidthT * 0.9, y2 + kMinWidthT * 0.9, 1);
          poly.push(x2 + kMinWidthT, y2);
        } else {
          poly.push(x2 - kMinWidthT, y2);
          poly.push(x2 - kMinWidthT * 0.6, y2 + kMinWidthT * 0.6);
          poly.push(x2, y2 + kMinWidthT);
          poly.push(x2 + kMinWidthT * 0.6, y2 + kMinWidthT * 0.6);
          poly.push(x2 + kMinWidthT, y2);
        }
        //poly.reverse(); // for fill-rule
        polygons.push(poly);
      } else if (a2 == 0 || a2 == 13 || a2 == 23) {
        var yOffset = 0;
        if (a2 == 13) {yOffset = kage.kAdjustKakatoL[opt2];}
        if (a2 == 23) {yOffset = kage.kAdjustKakatoR[opt2];}
        poly = new Polygon();
        poly.push(x2 + kMinWidthT, y2 + yOffset);
        poly.push(x2 + kMinWidthT / 2, y2 + yOffset + kMinWidthT * 0.375);
        poly.push(x2, y2 + yOffset + kMinWidthT / 2);
        poly.push(x2 - kMinWidthT / 2, y2 + yOffset);
        poly.push(x2 - kMinWidthT, y2 + yOffset - kMinWidthT);
        poly.push(x2 - kMinWidthT - kage.kMinWidthY * (a2 == 0 ? 1 : 0.5), y2 + yOffset - kMinWidthT * (a2 == 23 ? 2 : 3));
        poly.push(x2 - kMinWidthT, y2 + yOffset - kMinWidthT * (a2 == 23 ? 3 : 4));
        polygons.push(poly);
      }
    }
    else if(y1 == y2){ //if it is YOKO stroke, use x-axis
      if(a1 == 6){ //if it is KAGI's YOKO stroke, get bold
        poly = new Polygon();
        poly.push(x1, y1 - kMinWidthT);
        poly.push(x2, y2 - kMinWidthT);
        poly.push(x2, y2 + kMinWidthT);
        poly.push(x1, y1 + kMinWidthT);
        polygons.push(poly);
        
        if(a2 == 1 || a2 == 0 || a2 == 5){ // no need a2=1
          //KAGI NO YOKO BOU NO SAIGO NO MARU
          poly = new Polygon();
          if(kage.kUseCurve){
            if(x1 < x2){
              poly.push(x2, y2 - kMinWidthT);
              poly.push(x2 + kMinWidthT * 0.9, y2 - kMinWidthT * 0.9, 1);
              poly.push(x2 + kMinWidthT, y2);
              poly.push(x2 + kMinWidthT * 0.9, y2 + kMinWidthT * 0.9, 1);
              poly.push(x2, y2 + kMinWidthT);
            } else {
              poly.push(x2, y2 - kMinWidthT);
              poly.push(x2 - kMinWidthT * 0.9, y2 - kMinWidthT * 0.9, 1);
              poly.push(x2 - kMinWidthT, y2);
              poly.push(x2 - kMinWidthT * 0.9, y2 + kMinWidthT * 0.9, 1);
              poly.push(x2, y2 + kMinWidthT);
            }
          } else {
            if(x1 < x2){
              poly.push(x2, y2 - kMinWidthT);
              poly.push(x2 + kMinWidthT * 0.6, y2 - kMinWidthT * 0.6);
              poly.push(x2 + kMinWidthT, y2);
              poly.push(x2 + kMinWidthT * 0.6, y2 + kMinWidthT * 0.6);
              poly.push(x2, y2 + kMinWidthT);
            } else {
              poly.push(x2, y2 - kMinWidthT);
              poly.push(x2 - kMinWidthT * 0.6, y2 - kMinWidthT * 0.6);
              poly.push(x2 - kMinWidthT, y2);
              poly.push(x2 - kMinWidthT * 0.6, y2 + kMinWidthT * 0.6);
              poly.push(x2, y2 + kMinWidthT);
            }
          }
          polygons.push(poly);
        }
        
        if(a2 == 5){
          //KAGI NO YOKO BOU NO HANE
          poly = new Polygon();
          if(x1 < x2){
            poly.push(x2 + kMinWidthT, y2);
            poly.push(x2 + 2, y2 - kMinWidthT - kage.kWidth * (4 * (1 - opt1 / kage.kAdjustMageStep) + 1));
            poly.push(x2, y2 - kMinWidthT - kage.kWidth * (4 * (1 - opt1 / kage.kAdjustMageStep) + 1));
            poly.push(x2 - kMinWidthT, y2 - kMinWidthT + 1);
          } else {
            poly.push(x2 - kMinWidthT, y2);
            poly.push(x2 - 2, y2 - kMinWidthT - kage.kWidth * (4 * (1 - opt1 / kage.kAdjustMageStep) + 1));
            poly.push(x2, y2 - kMinWidthT - kage.kWidth * (4 * (1 - opt1 / kage.kAdjustMageStep) + 1));
            poly.push(x2 + kMinWidthT, y2 - kMinWidthT + 1);
          }
          //poly.reverse(); // for fill-rule
          polygons.push(poly);
        }
      }
      else{
        //always same
        poly = new Polygon(8);
        poly.set(0, x1 - kage.kMinWidthY, y1 - kage.kMinWidthY * 2);
        poly.set(1, x1, y1 - kage.kMinWidthY * 1.5);
        poly.set(2, x1 + kage.kMinWidthY * 8, y1 - kage.kMinWidthY);
        poly.set(3, x2 - kage.kMinWidthY, y2 - kage.kMinWidthY);
        poly.set(4, x2, y2 + kage.kMinWidthY);
        poly.set(5, x1 + kage.kMinWidthY * 10, y1 + kage.kMinWidthY);
        poly.set(6, x1 + kage.kMinWidthY, y1 + kage.kMinWidthY * 1.5);
        poly.set(7, x1, y1 + kage.kMinWidthY * 2);
        polygons.push(poly);
        
        //UROKO
        if(a2 == 0){
          var urokoScale = (kage.kMinWidthU / kage.kMinWidthY - 1.0) / 4.0 + 1.0;
          poly = new Polygon();
          poly.push(x2 - kage.kMinWidthY * 0.875, y2 - kage.kMinWidthY);
          poly.push(x2 - kage.kMinWidthY * 0.5, y2);
          poly.push(x2, y2 + kage.kMinWidthY);
          poly.push(x2 - kage.kAdjustUrokoX[opt2] * urokoScale * 2, y2 - kage.kMinWidthY);
          poly.push(x2 - kage.kAdjustUrokoX[opt2] * urokoScale, y2 - kage.kAdjustUrokoY[opt2] * urokoScale / 2);
          poly.push(x2 - kage.kAdjustUrokoX[opt2] * urokoScale / 2, y2 - kage.kAdjustUrokoY[opt2] * urokoScale * 0.75);
          polygons.push(poly);
        }
      }
    }
    else{ //for others, use x-axis
      rad = Math.atan((y2 - y1) / (x2 - x1));
      if((Math.abs(y2 - y1) < Math.abs(x2 - x1)) && (a1 != 6) && (a2 != 6) && !(x1 > x2)){ //ASAI KAUDO
        //always same
        poly = new Polygon(8);
        setRotated(poly, rad, 0, x1, y1, - kage.kMinWidthY     , - kage.kMinWidthY * 2);
        setRotated(poly, rad, 1, x1, y1, 0                     , - kage.kMinWidthY * 1.5);
        setRotated(poly, rad, 2, x1, y1, + kage.kMinWidthY * 8 , - kage.kMinWidthY);
        setRotated(poly, rad, 3, x2, y2, - kage.kMinWidthY     , - kage.kMinWidthY);
        setRotated(poly, rad, 4, x2, y2, 0                     , + kage.kMinWidthY);
        setRotated(poly, rad, 5, x1, y1, + kage.kMinWidthY * 10, + kage.kMinWidthY);
        setRotated(poly, rad, 6, x1, y1, + kage.kMinWidthY     , + kage.kMinWidthY * 1.5);
        setRotated(poly, rad, 7, x1, y1, 0                     , + kage.kMinWidthY * 2);
        polygons.push(poly);
        
        //UROKO
        if(a2 == 0){
          var urokoScale = (kage.kMinWidthU / kage.kMinWidthY - 1.0) / 4.0 + 1.0;
          poly = new Polygon();
          pushRotated(poly, rad, x2, y2, - kage.kMinWidthY * 0.875                  , - kage.kMinWidthY);
          pushRotated(poly, rad, x2, y2, - kage.kMinWidthY * 0.5                    , 0);
          pushRotated(poly, rad, x2, y2, 0                                          , + kage.kMinWidthY);
          pushRotated(poly, rad, x2, y2, - kage.kAdjustUrokoX[opt2] * urokoScale * 2, - kage.kMinWidthY);
          pushRotated(poly, rad, x2, y2, - kage.kAdjustUrokoX[opt2] * urokoScale    , - kage.kAdjustUrokoY[opt2] * urokoScale / 2);
          pushRotated(poly, rad, x2, y2, - kage.kAdjustUrokoX[opt2] * urokoScale / 2, - kage.kAdjustUrokoY[opt2] * urokoScale * 0.75);
          polygons.push(poly);
        }
      }
      
      else{ //KAKUDO GA FUKAI or KAGI NO YOKO BOU
        if(x1 > x2){ v = -1; } else{ v = 1; }
        poly = new Polygon(4);
        switch(a1){
        case 0:
          poly.set(0, x1 + Math.sin(rad) * kMinWidthT * v + kage.kMinWidthY * Math.cos(rad) * 0.5 * v,
                   y1 - Math.cos(rad) * kMinWidthT * v + kage.kMinWidthY * Math.sin(rad) * 0.5 * v);
          poly.set(3, x1 - Math.sin(rad) * kMinWidthT * v - kage.kMinWidthY * Math.cos(rad) * 0.5 * v,
                   y1 + Math.cos(rad) * kMinWidthT * v - kage.kMinWidthY * Math.sin(rad) * 0.5 * v);
          break;
        case 1:
        case 6:
          poly.set(0, x1 + Math.sin(rad) * kMinWidthT * v, y1 - Math.cos(rad) * kMinWidthT * v);
          poly.set(3, x1 - Math.sin(rad) * kMinWidthT * v, y1 + Math.cos(rad) * kMinWidthT * v);
          break;
        case 12:
          poly.set(0, x1 + Math.sin(rad) * kMinWidthT * v - kage.kMinWidthY * Math.cos(rad) * v,
                   y1 - Math.cos(rad) * kMinWidthT * v - kage.kMinWidthY * Math.sin(rad) * v);
          poly.set(3, x1 - Math.sin(rad) * kMinWidthT * v - (kMinWidthT + kage.kMinWidthY) * Math.cos(rad) * v,
                   y1 + Math.cos(rad) * kMinWidthT * v - (kMinWidthT + kage.kMinWidthY) * Math.sin(rad) * v);
          break;
        case 22:
          poly.set(0, x1 + (kMinWidthT * v + 1) / Math.sin(rad), y1 + 1);
          poly.set(3, x1 - (kMinWidthT * v) / Math.sin(rad), y1);
          break;
        case 32:
          poly.set(0, x1 + (kMinWidthT * v) / Math.sin(rad), y1);
          poly.set(3, x1 - (kMinWidthT * v) / Math.sin(rad), y1);
          break;
        }
        
        switch(a2){
        case 0:
          if(a1 == 6){
            poly.set(1, x2 + Math.sin(rad) * kMinWidthT * v, y2 - Math.cos(rad) * kMinWidthT * v);
            poly.set(2, x2 - Math.sin(rad) * kMinWidthT * v, y2 + Math.cos(rad) * kMinWidthT * v);
          }
          else{
            poly.set(1, x2 + Math.sin(rad) * kMinWidthT * v - kMinWidthT * 0.5 * Math.cos(rad) * v,
                     y2 - Math.cos(rad) * kMinWidthT * v - kMinWidthT * 0.5 * Math.sin(rad) * v);
            poly.set(2, x2 - Math.sin(rad) * kMinWidthT * v + kMinWidthT * 0.5 * Math.cos(rad) * v,
                     y2 + Math.cos(rad) * kMinWidthT * v + kMinWidthT * 0.5 * Math.sin(rad) * v);
          }
          break;
        case 1: // is needed?
        case 5:
          poly.set(1, x2 + Math.sin(rad) * kMinWidthT * v, y2 - Math.cos(rad) * kMinWidthT * v);
          poly.set(2, x2 - Math.sin(rad) * kMinWidthT * v, y2 + Math.cos(rad) * kMinWidthT * v);
          break;
        case 13:
          poly.set(1, x2 + Math.sin(rad) * kMinWidthT * v + kage.kAdjustKakatoL[opt2] * Math.cos(rad) * v,
                   y2 - Math.cos(rad) * kMinWidthT * v + kage.kAdjustKakatoL[opt2] * Math.sin(rad) * v);
          poly.set(2, x2 - Math.sin(rad) * kMinWidthT * v + (kage.kAdjustKakatoL[opt2] + kMinWidthT) * Math.cos(rad) * v,
                   y2 + Math.cos(rad) * kMinWidthT * v + (kage.kAdjustKakatoL[opt2] + kMinWidthT) * Math.sin(rad) * v);
          break;
        case 23:
          poly.set(1, x2 + Math.sin(rad) * kMinWidthT * v + kage.kAdjustKakatoR[opt2] * Math.cos(rad) * v,
                   y2 - Math.cos(rad) * kMinWidthT * v + kage.kAdjustKakatoR[opt2] * Math.sin(rad) * v);
          poly.set(2,
                   x2 - Math.sin(rad) * kMinWidthT * v + (kage.kAdjustKakatoR[opt2] + kMinWidthT) * Math.cos(rad) * v,
                   y2 + Math.cos(rad) * kMinWidthT * v + (kage.kAdjustKakatoR[opt2] + kMinWidthT) * Math.sin(rad) * v);
          break;
        case 32:
          poly.set(1, x2 + (kMinWidthT * v) / Math.sin(rad), y2);
          poly.set(2, x2 - (kMinWidthT * v) / Math.sin(rad), y2);
          break;
        }
        
        polygons.push(poly);
        
        if((a1 == 6) && (a2 == 0 || a2 == 5)){ //KAGI NO YOKO BOU NO SAIGO NO MARU
          poly = new Polygon();
          if(kage.kUseCurve){
            poly.push(x2 + Math.sin(rad) * kMinWidthT * v, y2 - Math.cos(rad) * kMinWidthT * v);
            poly.push(x2 - Math.cos(rad) * kMinWidthT * 0.9 * v + Math.sin(rad) * kMinWidthT * 0.9 * v,
                      y2 + Math.sin(rad) * kMinWidthT * 0.9 * v - Math.cos(rad) * kMinWidthT * 0.9 * v, 1);
            poly.push(x2 + Math.cos(rad) * kMinWidthT * v, y2 + Math.sin(rad) * kMinWidthT * v);
            poly.push(x2 + Math.cos(rad) * kMinWidthT * 0.9 * v - Math.sin(rad) * kMinWidthT * 0.9 * v,
                      y2 + Math.sin(rad) * kMinWidthT * 0.9 * v + Math.cos(rad) * kMinWidthT * 0.9 * v, 1);
            poly.push(x2 - Math.sin(rad) * kMinWidthT * v, y2 + Math.cos(rad) * kMinWidthT * v);
          } else {
            poly.push(x2 + Math.sin(rad) * kMinWidthT * v, y2 - Math.cos(rad) * kMinWidthT * v);
            poly.push(x2 + Math.cos(rad) * kMinWidthT * 0.8 * v + Math.sin(rad) * kMinWidthT * 0.6 * v,
                      y2 + Math.sin(rad) * kMinWidthT * 0.8 * v - Math.cos(rad) * kMinWidthT * 0.6 * v);
            poly.push(x2 + Math.cos(rad) * kMinWidthT * v, y2 + Math.sin(rad) * kMinWidthT * v);
            poly.push(x2 + Math.cos(rad) * kMinWidthT * 0.8 * v - Math.sin(rad) * kMinWidthT * 0.6 * v,
                      y2 + Math.sin(rad) * kMinWidthT * 0.8 * v + Math.cos(rad) * kMinWidthT * 0.6 * v);
            poly.push(x2 - Math.sin(rad) * kMinWidthT * v, y2 + Math.cos(rad) * kMinWidthT * v);
          }
          polygons.push(poly);
        }
        
        if(a1 == 6 && a2 == 5){
          //KAGI NO YOKO BOU NO HANE
          poly = new Polygon();
          if(x1 < x2){
            poly.push(x2 + (kMinWidthT - 1) * Math.sin(rad) * v, y2 - (kMinWidthT - 1) * Math.cos(rad) * v);
            poly.push(x2 + 2 * Math.cos(rad) * v + (kMinWidthT + kage.kWidth * 5) * Math.sin(rad) * v,
                      y2 + 2 * Math.sin(rad) * v - (kMinWidthT + kage.kWidth * 5) * Math.cos(rad) * v);
            poly.push(x2 + (kMinWidthT + kage.kWidth * 5) * Math.sin(rad) * v,
                      y2 - (kMinWidthT + kage.kWidth * 5) * Math.cos(rad) * v);
            poly.push(x2 + (kMinWidthT - 1) * Math.sin(rad) * v - kMinWidthT * Math.cos(rad) * v,
                      y2 - (kMinWidthT - 1) * Math.cos(rad) * v - kMinWidthT * Math.sin(rad) * v);
          } else {
            poly.push(x2 - (kMinWidthT - 1) * Math.sin(rad) * v, y2 + (kMinWidthT - 1) * Math.cos(rad) * v);
            poly.push(x2 + 2 * Math.cos(rad) * v - (kMinWidthT + kage.kWidth * 5) * Math.sin(rad) * v,
                      y2 + 2 * Math.sin(rad) * v + (kMinWidthT + kage.kWidth * 5) * Math.cos(rad) * v);
            poly.push(x2 - (kMinWidthT + kage.kWidth * 5) * Math.sin(rad) * v,
                      y2 + (kMinWidthT + kage.kWidth * 5) * Math.cos(rad) * v);
            poly.push(x2 + (kMinWidthT - 1) * Math.sin(rad) * v - kMinWidthT * Math.cos(rad) * v,
                      y2 - (kMinWidthT - 1) * Math.cos(rad) * v - kMinWidthT * Math.sin(rad) * v);
          }
          polygons.push(poly);
        }
        
        if(a1 == 22 || a1 == 27){ //SHIKAKU MIGIUE UROKO NANAME DEMO MASSUGU MUKI
          poly = new Polygon();
          poly.push(x1 - kMinWidthT, y1 - kage.kMinWidthY);
          poly.push(x1, y1 - kage.kMinWidthY - kage.kWidth);
          poly.push(x1 + kMinWidthT + kage.kWidth, y1 + kage.kMinWidthY);
          poly.push(x1 + kMinWidthT, y1 + kMinWidthT - 1);
          if (a1 == 27) {
            poly.push(x1, y1 + kMinWidthT + 2);
            poly.push(x1, y1);
          } else {
            poly.push(x1 - kMinWidthT, y1 + kMinWidthT + 4);
          }
          polygons.push(poly);
        }
        
        XX = Math.sin(rad) * v;
        XY = Math.cos(rad) * v * -1;
        YX = Math.cos(rad) * v;
        YY = Math.sin(rad) * v;
        
        if(a1 == 0){ //beginning of the storke
          poly = new Polygon();
          poly.push(x1 + kMinWidthT * XX + (kage.kMinWidthY * 0.5) * YX,
                    y1 + kMinWidthT * XY + (kage.kMinWidthY * 0.5) * YY);
          poly.push(x1 + (kMinWidthT + kMinWidthT * 0.5) * XX + (kage.kMinWidthY * 0.5 + kage.kMinWidthY) * YX,
                    y1 + (kMinWidthT + kMinWidthT * 0.5) * XY + (kage.kMinWidthY * 0.5 + kage.kMinWidthY) * YY);
          poly.push(x1 + kMinWidthT * XX + (kage.kMinWidthY * 0.5 + kage.kMinWidthY * 2) * YX - 2 * XX,
                    y1 + kMinWidthT * XY + (kage.kMinWidthY * 0.5 + kage.kMinWidthY * 2) * YY + 1 * XY);
          polygons.push(poly);
        }
      }
    }
  }
FINIS
		print;
	} else {
		print;
	}
}
