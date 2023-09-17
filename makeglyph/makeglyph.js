// arguments ...  0:target_char_name 1:related_parts 2:shotai 3:weight
// shotai ... mincho or gothic
// weight ... 1 3 5 7

load("../rotate.js");
load("engine/2d.js");
load("engine/curve.js");
load("engine/polygon.js");
load("engine/polygons.js");
load("engine/buhin.js");
load("engine/kage.js");
load("engine/kagecd.js");
load("engine/kagedf.js");

kage = new Kage();

if (arguments === undefined) {
  if (scriptArgs !== undefined) { // workaround for newer mozjs
    var arguments = scriptArgs;
  }
}

if (arguments[0] == "--") { // spidermonkey
  arguments.shift();
}

if(arguments[2] == "socho"){
  kage.kShotai = kage.kSocho;
}else if(arguments[2] == "gothic"){
  kage.kShotai = kage.kGothic;
}else if(arguments[2] == "latin"){
  kage.kShotai = kage.kLatin;
} else {
  kage.kShotai = kage.kMincho;
}

if(arguments[3] == 1){
  kage.kMinWidthY = 1;
  kage.kMinWidthU = 1;
  kage.kMinWidthT = 4;
  kage.kWidth = 3;
  kage.kKakato = 4;
} else if(arguments[3] == 5){
  kage.kMinWidthY = 3;
  kage.kMinWidthU = 3;
  kage.kMinWidthT = 8;
  kage.kWidth = 7;
  kage.kKakato = 2;
  kage.kMage = 13;
  kage.kAdjustTateStep = 5;
  kage.kAdjustMageStep = 6;
} else if(arguments[3] == 7){
  kage.kMinWidthY = 4;
  kage.kMinWidthU = 4;
  kage.kMinWidthT = 10;
  kage.kWidth = 9;
  kage.kKakato = 1;
  kage.kMage = 17;
  kage.kAdjustTateStep = 6;
  kage.kAdjustMageStep = 7;
} else if(arguments[3] == 9){
  kage.kMinWidthY = 4;
  kage.kMinWidthU = 5;
  kage.kMinWidthT = 12;
  kage.kWidth = 9;
  kage.kKakato = 0.5;
  kage.kMage = 20;
  kage.kAdjustTateStep = 7;
  kage.kAdjustMageStep = 8;
} else if(arguments[3] == 0){
  kage.kMinWidthY = 1;
  kage.kMinWidthU = 1;
  kage.kMinWidthT = 3;
  kage.kWidth = 2;
  kage.kKakato = 4;
} else if(arguments[3] == 105){
  kage.kMinWidthY = 2;
  kage.kMinWidthU = 3;
  kage.kMinWidthT = 8;
  kage.kWidth = 7;
  kage.kKakato = 1;
  kage.kMage = 13;
  kage.kAdjustTateStep = 5;
  kage.kAdjustMageStep = 6;
} else if(arguments[3] == 107){
  kage.kMinWidthY = 2;
  kage.kMinWidthU = 4;
  kage.kMinWidthT = 10;
  kage.kWidth = 9;
  kage.kKakato = 0.5;
  kage.kMage = 17;
  kage.kAdjustTateStep = 6;
  kage.kAdjustMageStep = 7;
} else if(arguments[3] == 109){
  kage.kMinWidthY = 2;
  kage.kMinWidthU = 4;
  kage.kMinWidthT = 10;
  kage.kWidth = 8;
  kage.kKakato = 0.3;
  kage.kMage = 17;
  kage.kAdjustTateStep = 5;
  kage.kAdjustMageStep = 7;
} else if(arguments[3] == 200){
  kage.kMinWidthY = 1.5;
  kage.kMinWidthU = 1.5;
  kage.kMinWidthT = 2;
  kage.kWidth = 2;
  kage.kKakato = 5;
  kage.kAdjustKakatoL = ([12, 10, 8, 6]);
  kage.kAdjustKakatoR = ([6, 5, 4, 3]);
} else if(arguments[3] == 201){
  kage.kMinWidthY = 2;
  kage.kMinWidthU = 2;
  kage.kMinWidthT = 3;
  kage.kWidth = 3;
  kage.kKakato = 5;
  kage.kAdjustKakatoL = ([12, 10, 8, 6]);
  kage.kAdjustKakatoR = ([6, 5, 4, 3]);
} else if(arguments[3] == 203){
  kage.kMinWidthY = 3;
  kage.kMinWidthU = 3;
  kage.kMinWidthT = 6;
  kage.kWidth = 5;
  kage.kKakato = 3;
  kage.kAdjustKakatoL = ([14, 12, 10, 8]);
  kage.kAdjustKakatoR = ([8, 6.5, 5, 3.5]);
} else if(arguments[3] == 205){
  kage.kMinWidthY = 4;
  kage.kMinWidthU = 4;
  kage.kMinWidthT = 8;
  kage.kWidth = 7;
  kage.kKakato = 1;
  kage.kMage = 13;
  kage.kAdjustTateStep = 5;
  kage.kAdjustMageStep = 6;
} else if(arguments[3] == 207){
  kage.kMinWidthY = 5;
  kage.kMinWidthU = 5;
  kage.kMinWidthT = 10;
  kage.kWidth = 9;
  kage.kKakato = 0.5;
  kage.kMage = 17;
  kage.kAdjustTateStep = 6;
  kage.kAdjustMageStep = 7;
} else {
  kage.kMinWidthY = 2;
  kage.kMinWidthU = 2;
  kage.kMinWidthT = 6;
  kage.kWidth = 5;
  kage.kKakato = 3;
}

if ((kage.kShotai == kage.kGothic || kage.kShotai == kage.kLatin) && (kage.kKakato >= 2)) {
  kage.kKakato -= 1;
}
polygons = new Polygons();

target = arguments[0];
buhin = arguments[1].replace(/\r\n|\n/g, "\r").replace(/\+|\t/g, " ");

temp = buhin.split("\r");
for(i = 0; i < temp.length; i++){
  temp2 = temp[i].split(" ");
  kage.kBuhin.push(temp2[0], temp2[1]);
}

kage.makeGlyph(polygons, target);
print(polygons.generateSVG());
