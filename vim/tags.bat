gfind . -regex ".*\.\(php\|js\|txt\|css\|phtml\|bat\|ini\|html\)" -not -regex ".*\(exe\|png\|git\|jpg\|jpeg\|bmp\).*" -type f -printf "%%f\t%%p\t1\n" >>filename
gsort -f filename >.filenametags
del filename

