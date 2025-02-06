rm -f faffing.zip
rm -f faffing.love
rm -f pub/faffing.exe
7z a -tzip -r faffing.love @listfile.txt
cat pub/love.exe faffing.love > pub/faffing.exe
7z a -tzip faffing.zip @listfile2.txt
butler push faffing.zip thegrumpygamedev/tree-punchers-of-splorr:windows