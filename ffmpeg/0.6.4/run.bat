@ECHO off

REM 7z https://github.com/mcmilk/7-Zip-zstd
REM brotli https://mirror.msys2.org/mingw/mingw32/mingw-w64-i686-brotli-1.0.9-5-any.pkg.tar.zst

IF NOT EXIST wasm.tar (
	ECHO wasm.tar not found
	PAUSE
	EXIT
)

IF NOT EXIST ffmpeg.exe (
	ECHO ffmpeg.exe not found
	PAUSE
	EXIT
)

IF NOT EXIST .htaccess (
	ECHO .htaccess not found
	PAUSE
	EXIT
)

7z x wasm.tar -aoa
DEL wasm.tar

ECHO. >> .htaccess
ECHO # Generated extra >> .htaccess

for /r %%i in (ffmpeg-mac, *.exe, *.js, *.wasm) do (
	brotli %%i -o %%i.br -Z -f

	ECHO ^<FilesMatch "(%%~nxi\.br)$"^> >> .htaccess
	ECHO 	Header set x-content-length %%~zi >> .htaccess
	ECHO ^</FilesMatch^> >> .htaccess

	DEL %%i
)