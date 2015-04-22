/  Kage\.prototype\.kGothic = /a \
  Kage.prototype.kSocho = 2;

/var strokesArray = this\.adjustKirikuchi/ {
s/var strokesArray = /var strokesArray = this.adjustRoof(this.adjustLeftTop(/
s/;/));/
}

/function getBox/i \
  function adjustLeftTop(strokesArray){ // strokesArray\
    if (this.kShotai == this.kSocho) {\
      var R2LDlines = new Array();\
      for(var i = 0; i < strokesArray.length; i++){\
        if ((strokesArray[i][0] == 2) && (strokesArray[i][2] % 100 == 7)) {\
          R2LDlines.push(\
            [strokesArray[i][3], strokesArray[i][4], strokesArray[i][5], strokesArray[i][6]],\
            [strokesArray[i][5], strokesArray[i][6], strokesArray[i][7] + this.kMinWidthT / 2, strokesArray[i][8]]);\
        }\
      }\
      for(var i = 0; i < strokesArray.length; i++){\
        if ((strokesArray[i][0] == 1) && (strokesArray[i][3] == strokesArray[i][5])) {\
          for (var R2LDindex = 0; R2LDindex < R2LDlines.length; R2LDindex++) {\
            var xx0 = strokesArray[i][3];\
            var yy0 = strokesArray[i][4];\
            var xx1 = R2LDlines[R2LDindex][0];\
            var yy1 = R2LDlines[R2LDindex][1];\
            var xx2 = R2LDlines[R2LDindex][2];\
            var yy2 = R2LDlines[R2LDindex][3];\
            if ((xx2 <= xx0) && (xx0 <= xx1) && (xx1 != xx2)) {\
              var slope = (yy2 - yy1) / (xx2 - xx1);\
              var yIntercept = yy1 - slope * xx1;\
              if ((yy0 < (xx0 * slope + yIntercept + this.kMinWidthY * 4)) && (yy0 > (xx0 * slope + yIntercept - this.kMinWidthY * 2))) {\
                strokesArray[i][1] += 100000; break;\
              }\
            }\
          }\
        }\
      }\
    }\
    return strokesArray;\
  }\
  Kage.prototype.adjustLeftTop = adjustLeftTop;\
\
  function adjustRoof(strokesArray){ // strokesArray\
    if (this.kShotai == this.kSocho) {\
      var horizLines = new Array();\
      for(var i = 0; i < strokesArray.length; i++){\
        if ((strokesArray[i][0] == 1) && (strokesArray[i][4] == strokesArray[i][6])) {\
          horizLines.push(\
            [strokesArray[i][3], strokesArray[i][4], strokesArray[i][5], strokesArray[i][6]]);\
        }\
      }\
      for(var i = 0; i < strokesArray.length; i++){\
        if ((strokesArray[i][0] == 2) && (strokesArray[i][1] == 0) && (strokesArray[i][2] == 7)) {\
          for (var lineIndex = 0; lineIndex < horizLines.length; lineIndex++) {\
            var xx0 = strokesArray[i][3];\
            var yy0 = strokesArray[i][4];\
            var xx1 = horizLines[lineIndex][0];\
            var yy1 = horizLines[lineIndex][1];\
            var xx2 = horizLines[lineIndex][2];\
            var yy2 = horizLines[lineIndex][3];\
            if ((xx1 <= xx0) && (xx0 <= xx2)) {\
              if ((yy0 < (yy1 + this.kMinWidthY * 4)) && (yy0 > (yy1 - this.kMinWidthY * 2))) {\
                strokesArray[i][1] += 1000000; break;\
              }\
            }\
          }\
        }\
      }\
    }\
    return strokesArray;\
  }\
  Kage.prototype.adjustRoof = adjustRoof;\
\

