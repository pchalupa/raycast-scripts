#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Compress Video
# @raycast.packageName Video Tools
# @raycast.author Petr Chalupa
# @raycast.description Compress a video file using ffmpeg. The input file is taken from the clipboard (as a file URL). The compressed video is saved in the same directory with "-compressed" appended to the filename.
# @raycast.icon 📦
# @raycast.mode compact

input=$(osascript -e 'try
	set f to POSIX path of (the clipboard as «class furl»)
	return f
	end try' 2>/dev/null || true)

dir=$(dirname "$input")
filename=$(basename "$input")
name="${filename%.*}"
container="mp4"
output="${dir}/${name}-compressed.${container}"

ffmpeg -y -i "$input" \
  -vf "scale=1280:-2" \
  -c:v hevc_videotoolbox -q:v 65 \
  -c:a aac -b:a 128k \
  -tag:v hvc1 \
  -allow_sw 0 \
  -realtime 0 \
  -movflags +faststart \
  "$output"

echo "Compressed video saved to: $(basename "$dir")"
