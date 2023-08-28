/load("engine\/polygon.js");/i \
load("../rotate.js");\
load("engine/2d.js");\
load("engine/curve.js");
/kage = new Kage();/ a \
\
if (arguments === undefined) {\
  if (scriptArgs !== undefined) { // workaround for newer mozjs\
    var arguments = scriptArgs;\
  }\
}
/if(arguments\[2\] == "gothic"){/c \
if(arguments[2] == "socho"){\
  kage.kShotai = kage.kSocho;\
}else if(arguments[2] == "latin"){\
  kage.kShotai = kage.kLatin;\
}else if(arguments[2] == "gothic"){
/if(arguments\[3\] == 1){/ {
n
a \
  kage.kMinWidthU = 1;
}
/} else if(arguments\[3\] == 5){/ {
n
a \
  kage.kMinWidthU = 3;
}
/} else if(arguments\[3\] == 7){/ {
i \
  kage.kMage = 13;\
  kage.kAdjustTateStep = 5;\
  kage.kAdjustMageStep = 6;
n
a \
  kage.kMinWidthU = 4;
}
/  kage.kKakato = 1;/ {
a \
  kage.kMage = 17;\
  kage.kAdjustTateStep = 6;\
  kage.kAdjustMageStep = 7;\
} else if(arguments[3] == 9){\
  kage.kMinWidthY = 4;\
  kage.kMinWidthU = 5;\
  kage.kMinWidthT = 12;\
  kage.kWidth = 9;\
  kage.kKakato = 0.5;\
  kage.kMage = 20;\
  kage.kAdjustTateStep = 7;\
  kage.kAdjustMageStep = 8;\
} else if(arguments[3] == 0){\
  kage.kMinWidthY = 1;\
  kage.kMinWidthU = 1;\
  kage.kMinWidthT = 3;\
  kage.kWidth = 2;\
  kage.kKakato = 4;\
} else if(arguments[3] == 105){\
  kage.kMinWidthY = 2;\
  kage.kMinWidthU = 3;\
  kage.kMinWidthT = 8;\
  kage.kWidth = 7;\
  kage.kKakato = 1;\
  kage.kMage = 13;\
  kage.kAdjustTateStep = 5;\
  kage.kAdjustMageStep = 6;\
} else if(arguments[3] == 107){\
  kage.kMinWidthY = 2;\
  kage.kMinWidthU = 4;\
  kage.kMinWidthT = 10;\
  kage.kWidth = 9;\
  kage.kKakato = 0.5;\
  kage.kMage = 17;\
  kage.kAdjustTateStep = 6;\
  kage.kAdjustMageStep = 7;\
} else if(arguments[3] == 109){\
  kage.kMinWidthY = 2;\
  kage.kMinWidthU = 4;\
  kage.kMinWidthT = 10;\
  kage.kWidth = 8;\
  kage.kKakato = 0.3;\
  kage.kMage = 17;\
  kage.kAdjustTateStep = 5;\
  kage.kAdjustMageStep = 7;\
} else if(arguments[3] == 200){\
  kage.kMinWidthY = 1.5;\
  kage.kMinWidthU = 1.5;\
  kage.kMinWidthT = 2;\
  kage.kWidth = 2;\
  kage.kKakato = 5;\
  kage.kAdjustKakatoL = ([12, 10, 8, 6]);\
  kage.kAdjustKakatoR = ([6, 5, 4, 3]);\
} else if(arguments[3] == 201){\
  kage.kMinWidthY = 2;\
  kage.kMinWidthU = 2;\
  kage.kMinWidthT = 3;\
  kage.kWidth = 3;\
  kage.kKakato = 5;\
  kage.kAdjustKakatoL = ([12, 10, 8, 6]);\
  kage.kAdjustKakatoR = ([6, 5, 4, 3]);\
} else if(arguments[3] == 203){\
  kage.kMinWidthY = 3;\
  kage.kMinWidthU = 3;\
  kage.kMinWidthT = 6;\
  kage.kWidth = 5;\
  kage.kKakato = 3;\
  kage.kAdjustKakatoL = ([14, 12, 10, 8]);\
  kage.kAdjustKakatoR = ([8, 6.5, 5, 3.5]);\
} else if(arguments[3] == 205){\
  kage.kMinWidthY = 4;\
  kage.kMinWidthU = 4;\
  kage.kMinWidthT = 8;\
  kage.kWidth = 7;\
  kage.kKakato = 1;\
  kage.kMage = 13;\
  kage.kAdjustTateStep = 5;\
  kage.kAdjustMageStep = 6;\
} else if(arguments[3] == 207){\
  kage.kMinWidthY = 5;\
  kage.kMinWidthU = 5;\
  kage.kMinWidthT = 10;\
  kage.kWidth = 9;\
  kage.kKakato = 0.5;\
  kage.kMage = 17;\
  kage.kAdjustTateStep = 6;\
  kage.kAdjustMageStep = 7;
n
n
a \
  kage.kMinWidthU = 2;
}
/polygons = new Polygons();/i \
if ((kage.kShotai == kage.kGothic || kage.kShotai == kage.kLatin) && (kage.kKakato >= 2)) {\
  kage.kKakato -= 1;\
}
