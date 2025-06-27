#!/bin/bash

# 7z https://github.com/mcmilk/7-Zip-zstd
# brotli https://mirror.msys2.org/mingw/mingw32/mingw-w64-i686-brotli-1.0.9-5-any.pkg.tar.zst

if [[ ! -f .htaccess ]] ; then
	echo .htaccess not found
	exit
fi

echo -e "\n#Generated extra" >> .htaccess

for filename in *.onnx ; do
	filesize=$(stat -f%z "$filename")
	echo "processing $filename ($filesize bytes)"
	
	brotli $filename -o "$filename.br" -Z -f

	echo "<FilesMatch \"($filename\.br)$\">" >> .htaccess
	echo "	Header set x-content-length $filesize" >> .htaccess
	echo "</FilesMatch>" >> .htaccess

	rm $filename
done