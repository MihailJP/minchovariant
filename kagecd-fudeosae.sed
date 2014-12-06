s/a1 == 22/(a1 == 22 || a1 == 27)/g
s/a1 == 7/(a1 == 7 || a1 == 27)/g
/switch(a1 % 100)/,/switch(a2 % 100)/ {
/case 7:/a \ \ \ \ case 27:
}
/suiheisen ni setsuzoku 2/ {
n
s/(a1 == 22 || a1 == 27)/a1 == 22/g
}
/up-right corner/,/}/ {
	/kMinWidthT + 4/c \      if (a1 == 27) {\
\        poly.push(x1 - cornerOffset, y1 + kMinWidthT + 2);\
\        poly.push(x1 - cornerOffset, y1);\
\      } else {\
\        poly.push(x1 - cornerOffset - kMinWidthT, y1 + kMinWidthT + 4);\
\      }
}
/SHIKAKU MIGIUE UROKO NANAME DEMO MASSUGU MUKI/,/}/ {
	/kMinWidthT + 4/c \          if (a1 == 27) {\
\            poly.push(x1, y1 + kMinWidthT + 2);\
\            poly.push(x1, y1);\
\          } else {\
\            poly.push(x1 - kMinWidthT, y1 + kMinWidthT + 4);\
\          }
}
