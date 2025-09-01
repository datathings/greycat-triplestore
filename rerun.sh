rm -rf gcdata
cd bin
rm -rf greycat
cp $(which greycat) .
cd ..
clear
greycat run import