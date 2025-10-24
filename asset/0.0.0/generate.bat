echo invalid media > invalid.txt

ffmpeg -hide_banner -filter_complex "smptehdbars=size=1280x720:rate=30000/1001,drawtext=fontfile=c\\:/Windows/Fonts/arial.ttf:timecode=00\\:00\\:00.00:rate=30000/1001:fontsize=72:fontcolor=white:x=(w-tw)/2:y=10*h/100:box=1:boxcolor=0x00000000@1[vout];sine=frequency=440:sample_rate=48000:beep_factor=2[aout]" -map [vout] -map [aout] -t 00:01:00.000 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y "bars_h264_1280x720_30fps_aac_stereo_60s_1MB.mp4"

ffmpeg -hide_banner -filter_complex "smptehdbars=size=400x120:rate=60,drawtext=fontfile=c\\:/Windows/Fonts/arial.ttf:timecode=00\\:00\\:00.00:rate=60:fontsize=72:fontcolor=white:x=(w-tw)/2:y=(h-th)/2:box=1:boxcolor=0x00000000@1;sine=frequency=440:sample_rate=48000:beep_factor=2" -t 60 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y bars_h264_400x120_60fps_aac_stereo_60s_1MB.mp4

ffmpeg -hide_banner -filter_complex "sine=frequency=440:sample_rate=48000:beep_factor=2" -t 00:01:00.000 -c:a aac -ac 2 "beep_aac_stereo_60s_0MB.aac"

ffmpeg -f lavfi -i color=color=ff0000:size=512x512:rate=240 -f lavfi -i color=color=00000000:size=512x512:rate=240 -filter_complex "[1]drawbox=x=0:y=(ih-60)/2:width=iw:height=60:color=00ff00:thickness=60,rotate=n/240*PI[r];[0][r]overlay" -f lavfi -i sine=frequency=440:sample_rate=48000:beep_factor=2 -t 00:01:00.000 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y  rotator_h264_512x512_240fps_aac_stereo_60s_6MB.mp4 -y

ffmpeg -f lavfi -i color=color=ffffff:size=500x500:rate=10:duration=3 -filter_complex "[0]rotate=n/60*PI,split[a][b];[a][b]alphamerge,split[a][b];[a]palettegen=reserve_transparent=on[p];[b][p]paletteuse" rotator_gif_500x500_0MB.gif -y

ffmpeg -i rotator_gif_500x500_0MB.gif -c libvpx -pix_fmt yuva420p -auto-alt-ref 0 rotator_vp8_500x500_0MB.webm -y

curl https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Creative_Commons/Sean_Fournier/Sean_Fournier_-_Singles/Sean_Fournier_-_06_-_Falling_For_You_Piano_Version.mp3 --output sf_mp3_stereo_203s_4MB.mp3

REM .aac does not exist https://trac.ffmpeg.org/ticket/9708
REM ffmpeg -i sf_mp3_stereo_203s_4MB.mp3 -vn -acodec aac sf_aac_stereo_218s_3MB.aac

ffmpeg -i sf_mp3_stereo_203s_4MB.mp3 -vn -acodec aac sf_aac_stereo_203s_3MB.m4a

curl http://ftp.nluug.nl/pub/graphics/blender/demo/movies/BBB/bbb_sunflower_1080p_60fps_normal.mp4 --output bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=30,scale=1280x720" -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_h264_1280x720_30fps_aac_stereo_30s_4MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=30,scale=1280x720" -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 1 -f mp4 -movflags +faststart -y bbb_h264_1280x720_30fps_aac_mono_30s_4MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=30,scale=1280x720" -t 30 -map 0:v -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -map 0:a:0 -c:a:0 ac3 -map 0:a:0 -c:a:1 eac3 -map 0:a:0 -c:a:2 aac -ac 2 -f mp4 -movflags +faststart -y bbb_h264_1280x720_30fps_ac3_eac3_aac_stereo_30s_6MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=30,scale=86x48" -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_h264_86x48_30fps_aac_stereo_30s_0MB.mp4

ffmpeg -ss 306 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "scale=960x540" -t 20 -c:v libx264 -pix_fmt:v yuv420p -preset:v veryslow -c:a copy -f mp4 -movflags +faststart -y bbb_h264_960x540_60fps_ac3_51_20s_4MB.mp4

ffmpeg -ss 306 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "scale=960x540" -t 20 -c:v libx264 -pix_fmt:v yuv420p -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_h264_960x540_60fps_aac_stereo_20s_3MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=10" -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_h264_1920x1080_10fps_aac_stereo_30s_7MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=30,scale=960x540" -t 10 -c:v libvpx-vp9 -crf 30 -pix_fmt yuv420p10le -c:a libopus -ac 2 bbb_vp9_960x540_30fps_opus_stereo_10s_1MB.webm -y

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=30,scale=100x100" -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_h264_100x100_30fps_aac_stereo_30s_0MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=30,scale=200x100" -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_h264_200x100_30fps_aac_stereo_30s_0MB.mp4


REM do not modify, used for performance test!
ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v medium -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_h264_1920x1080_60fps_aac_stereo_30s_11MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=25,scale=1280x720" -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 6 -f mp4 -movflags +faststart -y bbb_h264_1280x720_25fps_aac_51_30s_5MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=25,scale=640x360" -t 5 -c:v libaom-av1 -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_av1_640x360_25fps_aac_stereo_5s_0MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=25,scale=640x360" -t 5 -c:v libvpx -c:a libvorbis -ac 2 -f matroska -movflags +faststart -y bbb_vp8_640x360_25fps_vorbis_stereo_5s_0MB.mkv

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=25,scale=640x360" -t 5 -c:v libvpx-vp9 -crf 30 -c:a libopus -ac 2 -f mp4 -movflags +faststart -y bbb_vp9_640x360_25fps_opus_stereo_5s_0MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=15,scale=640x360,split[a][b];[a]palettegen=stats_mode=single[a];[b][a]paletteuse" -t 5 -loop 0 -y bbb_gif_640x360_15fps_5s_9MB.gif

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=15,scale=640x360" -t 5 -loop 0 -y bbb_webp_640x360_15fps_5s_1MB.webp

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=10,scale=320x180" -t 5 -f apng -loop 0 -y bbb_apng_320x180_10fps_5s_5MB.png

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=15,scale=640x360" -t 5 -loop 0 -y bbb_av1_640x360_15fps_5s_0MB.avif

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=15,scale=640x360" -t 5 -loop 0 -y bbb_mjpeg_640x360_15fps_5s_0MB.mjpeg

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "scale=1280x720" -vframes 1 -y bbb_jpeg_1280x720_0MB.jpeg

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -filter_complex \
	"[0:v]fps=30,scale=1280x720[v0];[0:v]fps=20,scale=640x360[v1];[0:v]fps=10,scale=320x180[v2];[0:a]pan=mono[a1];[0:a]pan=5.1|c0=c0|c1=c1|c2=c2|c3=c3|c4=c4|c5=c5[a2]" \
	-t 30 \
	-map 0:a:0 -c:a:0 ac3 \
	-map "[a1]" -c:a:1 eac3 \
	-map "[a2]" -c:a:2 aac \
	-map "[v0]" -c:v:0 libx264 -pix_fmt:v:0 yuv420p -crf:v:0 23 -profile:v:0 high -preset:v:0 veryslow \
	-map "[v1]" -c:v:1 libx265 -tag:v:1 hvc1 -crf:v:1 26 -preset:v:1 slow -bf 0 \
	-map "[v2]" -c:v:2 libaom-av1 -cpu-used 8 \
	-f mp4 -movflags +faststart -y bbb_ac3_stereo_eac3_mono_aac_51_h264_1280x720_30fps_h265_640x360_20fps_av1_320x180_10fps_30s_8MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=30,scale=240x135,setparams=color_trc=linear" -t 5 -c:v prores -pix_fmt:v yuv422p10le -an -y bbb_prores_240x135_30fps_5s_2MB.mov

ffmpeg -loop 1 -i bbb_jpeg_1280x720_0MB.jpeg -t 10 -r 25 -g 250 -c:v libx264 -x264-params keyint=250:scenecut=0 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v medium -f mp4 -movflags +faststart -an -y bbb_h264_1280x720_25fps_10s_static_0MB.mp4

curl http://ftp.nluug.nl/pub/graphics/blender/demo/movies/Sintel.2010.1080p.mkv --output sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -t 30 -y sintel_h264_1920x818_24fps_aac_stereo_30s_6MB.mp4

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -vf "scale=640:-2" -c:v h264_videotoolbox -pix_fmt:v yuv420p -c:a aac -ac 2 -g 300 -bf 1 -map 0:v -map 0:a -f mp4 -t 13 -map_chapters -1 -y sintel_h264_640x272_24fps_B_aac_stereo_13s_0MB.mp4

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a ac3 -ac 2 -f mp4 -movflags +faststart -t 30 -y sintel_h264_1920x818_24fps_ac3_stereo_30s_6MB.mp4

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -vn -c:a ac3 -ac 2 -t 30 -y sintel_ac3_stereo_30s_1MB.ac3

ffmpeg -i sintel_h264_1920x818_24fps_aac_stereo_30s_7MB.mp4 -c copy -an sintel_h264_1920x818_24fps_30s_7MB.mp4

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v libx265 -tag:v hvc1 -crf:v 26 -preset:v slow -bf 0 -c:a aac -ac 2 -f mp4 -movflags +faststart -t 30 -y sintel_h265_1920x818_24fps_aac_stereo_30s_4MB.mp4

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v libvpx -c:a libvorbis -ac 2 -t 30 -y sintel_vp8_1920x818_24fps_vorbis_stereo_30s_1MB.webm

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v libvpx-vp9 -crf 30 -c:a libopus -ac 2 -t 30 -y sintel_vp9_1920x818_24fps_opus_stereo_30s_5MB.webm

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v mpeg1video -c:a mp2 -ac 2 -t 30 -y sintel_mpeg1_1920x818_24fps_mp2_stereo_30s_5MB.mpg

curl http://ftp.nluug.nl/pub/graphics/blender/demo/movies/ToS/tears_of_steel_1080p.mov --output tos_h264_1920x800_24fps_mp3_stereo_734s_583MB.mov

ffmpeg -ss 555 -i tos_h264_1920x800_24fps_mp3_stereo_734s_583MB.mov -vf "scale=1280:-2" -t 10 -c:v libx264 -pix_fmt:v yuv420p -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y tos_h264_1280x534_24fps_aac_stereo_10s_5MB.mp4

ffmpeg -i tos_h264_1920x800_24fps_mp3_stereo_734s_583MB.mov -vf "scale=640:-2" -c:v libx264 -profile:v high -preset:v veryslow -b:v 120k -pix_fmt:v yuv420p -c:a aac -ac 2 -f mp4 -movflags +faststart -y tos_h264_640x266_aac_stereo_734s_23MB.mp4

ffmpeg -ss 555 -to 655 -i tos_h264_640x266_aac_stereo_734s_23MB.mp4 -codec copy -copyts -y tos_h264_640x266_aac_stereo_100s_3MB.mp4
ffmpeg -ss 400 -to 450 -i tos_h264_640x266_aac_stereo_734s_23MB.mp4 -codec copy -copyts -y tos_h264_640x266_aac_stereo_50s_1MB.mkv

ffmpeg -i tos_h264_1920x800_24fps_mp3_stereo_734s_583MB.mov -vf "scale=640:-2" -c:v libx265 -tag:v hvc1 -b:v 120k -pix_fmt:v yuv420p -c:a aac -ac 2 -f mp4 -y tos_h265_640x266_aac_stereo_734s_23MB.mp4

ffmpeg -i tos_h264_1920x800_24fps_mp3_stereo_734s_583MB.mov -vn -c:a copy -f mp4 -movflags +faststart -y tos_mp3_stereo_734s_17MB.mp4

curl https://download.blender.org/demo/movies/ToS/subtitles/TOS-en.srt --output tos_en_0MB.srt

curl http://ftp.nluug.nl/pub/graphics/blender/demo/movies/BBB/bbb_sunflower_2160p_60fps_normal.mp4 --output bbb_h264_3840x2160_60fps_mp3_stereo_ac3_51_634s_673MB.mp4

copy sintel_vp8_1920x818_24fps_vorbis_stereo_30s_1MB.webm "sintel_vp8_1920x818_24fps_vorbis_stereo_30s_1MB_chars čř.webm"
copy sf_aac_stereo_203s_3MB.m4a "sf_aac_stereo_203s_3MB_chars čř.m4a"

ffmpeg -filter_complex "color=black:36x36:1,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=1:fontsize=8:fontcolor=white" -t 10 -c:v libx264 -preset:v veryslow -f mp4 -movflags +faststart -y counter_h264_36x36_1fps_10s_0MB.mp4
ffmpeg -filter_complex "color=black:36x36:10,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=10:fontsize=8:fontcolor=white" -t 10 -c:v libx264 -preset:v veryslow -f mp4 -movflags +faststart -y counter_h264_36x36_10fps_10s_0MB.mp4
ffmpeg -filter_complex "color=black:36x36:23.976,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=23.976:fontsize=8:fontcolor=white" -t 10 -c:v libx264 -preset:v veryslow -f mp4 -movflags +faststart -y counter_h264_36x36_23.976fps_10s_0MB.mp4
ffmpeg -filter_complex "color=black:36x36:24,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=24:fontsize=8:fontcolor=white" -t 10 -c:v libx264 -preset:v veryslow -f mp4 -movflags +faststart -y counter_h264_36x36_24fps_10s_0MB.mp4
ffmpeg -filter_complex "color=black:36x36:25,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=25:fontsize=8:fontcolor=white" -t 10 -c:v libx264 -preset:v veryslow -f mp4 -movflags +faststart -y counter_h264_36x36_25fps_10s_0MB.mp4
ffmpeg -filter_complex "color=black:36x36:30,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=30:fontsize=8:fontcolor=white" -t 10 -c:v libx264 -preset:v veryslow -f mp4 -movflags +faststart -y counter_h264_36x36_30fps_10s_0MB.mp4
ffmpeg -filter_complex "color=black:36x36:60,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=60:fontsize=8:fontcolor=white" -t 10 -c:v libx264 -preset:v veryslow -f mp4 -movflags +faststart -y counter_h264_36x36_60fps_10s_0MB.mp4
ffmpeg -filter_complex "color=black:36x36:120,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=120:fontsize=8:fontcolor=white" -t 10 -c:v libx264 -preset:v veryslow -f mp4 -movflags +faststart -y counter_h264_36x36_120fps_10s_0MB.mp4
ffmpeg -filter_complex "color=black:36x36:240,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=240:fontsize=8:fontcolor=white" -t 10 -c:v libx264 -preset:v veryslow -f mp4 -movflags +faststart -y counter_h264_36x36_240fps_10s_0MB.mp4

ffmpeg -filter_complex "color=black:36x36:23.976,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=23.976:fontsize=8:fontcolor=white" -t 10 -c:v libx264 -preset:v veryslow -f matroska -movflags +faststart -y counter_h264_36x36_23.976fps_10s_0MB.mkv
ffmpeg -filter_complex "color=black:36x36:30,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=30:fontsize=8:fontcolor=white" -t 10 -c:v libx264 -preset:v veryslow -f matroska -movflags +faststart -y counter_h264_36x36_30fps_10s_0MB.mkv

ffmpeg -filter_complex "color=black:36x36:23.976,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=23.976:fontsize=8:fontcolor=white" -t 10 -y counter_gif_36x36_23.976fps_10s_0MB.gif
ffmpeg -filter_complex "color=black:36x36:30,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=30:fontsize=8:fontcolor=white" -t 10 -y counter_gif_36x36_30fps_10s_0MB.gif

ffmpeg -filter_complex "color=black:36x36:23.976,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=23.976:fontsize=8:fontcolor=white" -t 10 -c:v mpeg1video -y counter_mpeg1_36x36_23.976fps_10s_0MB.mp4
ffmpeg -filter_complex "color=black:36x36:30,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=30:fontsize=8:fontcolor=white" -t 10 -c:v mpeg1video -y counter_mpeg1_36x36_30fps_10s_0MB.mp4

ffmpeg -filter_complex "color=black:36x36:24,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=24:fontsize=8:fontcolor=white" -t 60 -c:v libx265 -tag:v hvc1 -preset:v veryslow -f mp4 -movflags +faststart -y counter_h265_36x36_24fps_0MB.mp4

ffmpeg -filter_complex "color=duration=4:c=black:s=200x200:rate=24,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=24:fontsize=16:fontcolor=white,sine=duration=2:frequency=440:sample_rate=48000:beep_factor=2" -c:v libx264 -preset:v veryslow -c:a aac -ac 2 -y counter_video_4s_audio_2s.mp4 -y
ffmpeg -filter_complex "color=duration=4:c=black:s=200x200:rate=24,drawtext=fontfile=dogicapixel.ttf:text='%%{frame_num}':rate=24:fontsize=16:fontcolor=white,sine=duration=8:frequency=440:sample_rate=48000:beep_factor=2" -c:v libx264 -preset:v veryslow -c:a aac -ac 2 -y counter_video_4s_audio_8s.mp4 -y

curl https://raw.githubusercontent.com/recurser/exif-orientation-examples/master/Portrait_0.jpg --output rotated_jpeg_1200x1800_0_0MB.jpg
curl https://raw.githubusercontent.com/recurser/exif-orientation-examples/master/Portrait_1.jpg --output rotated_jpeg_1200x1800_1_0MB.jpg
curl https://raw.githubusercontent.com/recurser/exif-orientation-examples/master/Portrait_2.jpg --output rotated_jpeg_1200x1800_2_0MB.jpg
curl https://raw.githubusercontent.com/recurser/exif-orientation-examples/master/Portrait_3.jpg --output rotated_jpeg_1200x1800_3_0MB.jpg
curl https://raw.githubusercontent.com/recurser/exif-orientation-examples/master/Portrait_4.jpg --output rotated_jpeg_1200x1800_4_0MB.jpg
curl https://raw.githubusercontent.com/recurser/exif-orientation-examples/master/Portrait_5.jpg --output rotated_jpeg_1200x1800_5_0MB.jpg
curl https://raw.githubusercontent.com/recurser/exif-orientation-examples/master/Portrait_6.jpg --output rotated_jpeg_1200x1800_6_0MB.jpg
curl https://raw.githubusercontent.com/recurser/exif-orientation-examples/master/Portrait_7.jpg --output rotated_jpeg_1200x1800_7_0MB.jpg
curl https://raw.githubusercontent.com/recurser/exif-orientation-examples/master/Portrait_8.jpg --output rotated_jpeg_1200x1800_8_0MB.jpg

curl https://raw.githubusercontent.com/chrisdavidmills/html5-captions-and-subtitles-content-kit/gh-pages/demo/step4/vtt/sintel-captions-en.vtt --output sintel_captions_en.vtt

curl https://github.com/ChineseCubes/react-vtt/raw/master/examples/demo/assets/chocolate_rain.mp4 -L --output chocolate_rain_h264_320x240_29.97fps_aac_stereo_292s_12MB.mp4

REM customized by hand
REM curl https://github.com/ChineseCubes/react-vtt/raw/master/examples/demo/assets/chocolate_rain.vtt -L --output chocolate_rain_en_0MB.vtt

REM downloaded from youtube https://www.youtube.com/watch?v=MnrJzXM7a6o to jobs_h264_640x352_30fps_aac_stereo_619s_15MB.mp4

curl https://dotlottie.io/sample_files/animation.lottie --output lottie_generic_500x500_60fps_3s_0M.lottie
curl https://dotlottie.io/sample_files/animation-external-image.lottie --output lottie_external_image_500x500_60fps_3s_0M.lottie
curl https://dotlottie.io/sample_files/animation-inline-image.lottie --output lottie_inlines_image_500x500_60fps_3s_0M.lottie
curl https://fonts.gstatic.com/s/e/notoemoji/latest/1f980/lottie.json --output lottie_crab_512x512_60fps_2s_0M.json
curl https://fonts.gstatic.com/s/e/notoemoji/latest/1f389/lottie.json --output lottie_party_1024x1024_60fps_1s_0M.lottie

REM downloaded from https://app.lottiefiles.com/animation/f77a0045-b43d-465b-b12e-101b7aebaa61 to lottie_panda_182x182_60fps_2s_0M.lottie

REM download from https://rive.app/community/5965-11570-viking-strike/ to rive_viking_680x500_60fps_0M.riv
REM download from https://rive.app/community/515-981-buttery-smooth-animations/ to rive_van_1920x1080_60fps_0M.riv
REM download from https://rive.app/community/5998-11669-swinging-monkey/ to rive_monkey_1080x1080_60fps_0MB.riv
REM download from https://rive.app/community/5063-10215-sk8r-boi/ to rive_sk8r_alpha_500x500_60fps_0MB.riv

REM download from https://cdn.svgator.com/assets/main-page/fold2.5/svgator-demo-files.zip to svg_animated_css_bell_200x150_0MB.svg
REM download from https://cdn.svgator.com/assets/main-page/fold2.5/svgator-demo-files.zip to svg_animated_script_bell_200x150_0MB.svg
REM download from https://cdn.svgator.com/images/2023/03/stopwatch-svg-animation.svg to svg_animated_stopwatch_263x150_0MB.svg
REM download from https://cdn.svgator.com/images/2023/03/message-delivered-to-mailbox-animation.svg to svg_animated_mailbox_263x150_0MB.svg

ffmpeg -i blured_jpeg_300x600_0MB.jpg -i bbb_av1_640x360_25fps_aac_stereo_5s_0MB.mp4 -i logo_jpeg_510x93_0MB.jpg -i sintel_h264_1920x818_24fps_ac3_stereo_30s_6MB.mp4 -c copy -map 0:v -map 1:a -map 1:v -map 2:v -map 3:v -map 3:a  mix_iaviva_6MB.mp4

REM used https://obsproject.com/ to create VFR for https://youtu.be/xKYd4vFwdA8?si=EUPWmWwG-JkrZ8p6 
REM obs_synctest_h264_960x540_vfr_aac_stereo_22s_7MB.mkv `ffmpeg -i INPUT -vf vfrdet -an -f null -`
ffmpeg -i obs_synctest_h264_960x540_vfr_aac_stereo_22s_7MB.mkv -c copy obs_synctest_h264_960x540_vfr_aac_stereo_22s_7MB.mp4

ffmpeg -i premultiplyTest_png_256x256_0MB.png -f webm -vcodec libvpx -auto-alt-ref 0 -r 1 -t 1 -y premultiplyTest_vp8_256x256_1fps_1s_0MB.webm
ffmpeg -i premultiplyTest_png_256x256_0MB.png -f webm -vcodec libvpx-vp9 -auto-alt-ref 0 -r 1 -t 1 -y premultiplyTest_vp9_256x256_1fps_1s_0MB.webm
ffmpeg -i premultiplyTest_png_256x256_0MB.png -f mp4 -vcodec libvpx-vp9 -auto-alt-ref 0 -r 1 -t 1 -y premultiplyTest_vp9_256x256_1fps_1s_0MB.mp4
ffmpeg -i premultiplyTest_png_256x256_0MB.png -f matroska -vcodec libvpx-vp9 -auto-alt-ref 0 -r 1 -t 1 -y premultiplyTest_vp9_256x256_1fps_1s_0MB.mkv
ffmpeg -c:v libvpx-vp9 -i premultiplyTest_vp9_256x256_1fps_1s_0MB.webm -vframes 1 -f rawvideo -vcodec rawvideo -pix_fmt rgba premultiplyTest_rgba_256x256_0MB.rgba -y
ffmpeg -i premultiplyTest_png_256x256_0MB.png -vcodec hevc_videotoolbox -r 1 -t 1 -vtag hvc1 -alpha_quality 1 -y premultiplyTest_h265_256x256_1fps_1s_0MB.mp4
ffmpeg -i premultiplyTest_png_256x256_0MB.png -filter_complex "[0]split[v][v1];[v1]alphaextract[v1]" -map "[v]" -map "[v1]" -vcodec libaom-av1 -r 1 -t 1 -y premultiplyTest_av1_256x256_1fps_1s_0MB.avif
ffmpeg -i premultiplyTest_png_256x256_0MB.png -r 1 -t 1 -y premultiplyTest_webp_256x256_1fps_1s_0MB.webp

REM downloaded via cobalt.tools https://www.youtube.com/watch?v=NbMMIQgEjDM to metallica_opus_stereo_349s_4MB.opus
REM downloaded via cobalt.tools https://www.youtube.com/watch?v=zA1zCZI_wxk to metallica_opus_stereo_382s_6MB.opus

REM downloaded via cobalt.tools https://www.youtube.com/watch?v=NJfLFjauXbs to hanszimmer_opus_stereo_9541s_151MB.opus
REM downloaded via cobalt.tools https://www.youtube.com/watch?v=UMUCtNtKlJ0 to hanszimmer_opus_stereo_463s_7MB.opus

REM crbug_333325020.h264 is first 3000 bytes of h264 VideoEncoder chunk generated in studio using heavy noise filter ( related to https://localhost/wide.video/app-poc/html-VideoEncoder/crbug-VideoFrame-bitrate.html )

curl https://www.elecard.com/storage/video/NovosobornayaSquare_1920x1080.mp4 --output nss_h266_1920x1080_60fps_10s_4MB.mp4

REM counter_h265_648x648_30fps_aac_mono_86s_2MB.mp4 downloaded from https://github.com/stashapp/stash/issues/4124#issuecomment-1720057183

REM fasterwhisper_mp3_stereo_55s_0MB.mp3 download from https://github.com/SYSTRAN/faster-whisper/issues/81#issuecomment-1484051516 reported https://trac.ffmpeg.org/ticket/11429

ffmpeg -i fasterwhisper_mp3_stereo_55s_0MB.mp3 -i logo_png_510x93_alpha_0MB.png -map 0:0 -map 1:0 -c copy -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" fasterwhisper_mp3_stereo_55s_withLogo_0MB.mp3

REM pixelkid1_mjpeg_1920x1080_30fps_pcm_mono_10s_9MB.avi created using LAMAX PixelKid1

REM downloaded via cobalt.tools https://www.youtube.com/watch?v=sw_FDQ5VsA8 to shaky_driving_h264_1920x1080_60fps_40s_29MB.mp4
ffmpeg -i shaky_driving_h264_1920x1080_60fps_40s_29MB.mp4 -c copy shaky_driving_h264_1920x1080_60fps_40s_29MB.mkv

REM downloaded via cobalt.tools https://www.youtube.com/watch?v=a_cFHDpAAis to shaky_raven_h264_1920x1080_30fps_31s_14MB.mp4

REM zzile_h264_1080x1920_25fps_aac_stereo_4s_8MB.mp4 via reddit user zzile (2025-09-07 via reddit chats) created by Vivo v30 Lite phone

REM yt-dlp "https://www.youtube.com/watch?v=hEyWqVfY4vo -o mm_vp9_1920x1080_29.97fps_aac_stereo_98s_15MB.mp4"
ffmpeg -i mm_vp9_1920x1080_29.97fps_aac_stereo_98s_15MB.mp4 -filter:v "fps=10,crop=1356:1017:261:24,scale=360:270" -c:v libvpx-vp9 -b:v 0 -crf 30 -deadline best -row-mt 1 -c:a copy mm_vp9_360x270_10fps_aac_stereo_98s_4MB.mp4