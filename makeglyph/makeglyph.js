// arguments ...  0:target_char_name 1:related_parts 2:shotai 3:weight
// shotai ... mincho or gothic
// weight ... 1 3 5 7

load("engine/polygon.js");
load("engine/polygons.js");
load("engine/buhin.js");
load("engine/kage.js");
load("engine/kagecd.js");
load("engine/kagedf.js");

kage = new Kage();

if(arguments[2] == "gothic"){
  kage.kShotai = kage.kGothic;
} else {
  kage.kShotai = kage.kMincho;
}

if(arguments[3] == 1){
  kage.kMinWidthY = 1;
  kage.kMinWidthT = 4;
  kage.kWidth = 3;
  kage.kKakato = 4;
} else if(arguments[3] == 5){
  kage.kMinWidthY = 3;
  kage.kMinWidthT = 8;
  kage.kWidth = 7;
  kage.kKakato = 2;
} else if(arguments[3] == 7){
  kage.kMinWidthY = 4;
  kage.kMinWidthT = 10;
  kage.kWidth = 9;
  kage.kKakato = 1;
} else {
  kage.kMinWidthY = 2;
  kage.kMinWidthT = 6;
  kage.kWidth = 5;
  kage.kKakato = 3;
}

polygons = new Polygons();

target = (unescape(arguments[0]));
buhin = (unescape(arguments[1])).replace(/\r\n|\n/g, "\r").replace(/\+|\t/g, " ");

temp = buhin.split("\r");
for(i = 0; i < temp.length; i++){
  temp2 = temp[i].split(" ");
  kage.kBuhin.push(temp2[0], temp2[1]);
}

kage.makeGlyph(polygons, target);
print(polygons.generateSVG());
