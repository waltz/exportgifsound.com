#!/usr/bin/env bash

set -x
set -e

# takes a gif and a youtube url and makes an mp4
# requires youtube-dl and ffmpeg

GIF_URL=$1
YOUTUBE_URL=$2
OFFSET=$3
CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
YOUTUBE_DL=$CURRENT_PATH/vendor/youtube-dl

# cleanup any other outputs
rm -f out.mp4

# download the gif
curl $GIF_URL > image.gif

# convert the gif to an mp4
yes | ffmpeg \
  -i image.gif \
  -pix_fmt yuv420p \
  -r 30 \
  -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2"\
  video-no-audio.mp4

# get the audio file. 140 is the code for the m4a audio track
$YOUTUBE_DL \
  --format 140 \
  -o audio.m4a \
  $YOUTUBE_URL

# combine the two videos
ffmpeg \
  -i video-no-audio.mp4\
  -ss $OFFSET\
  -i audio.m4a\
  -c copy\
  -map 0:v:0\
  -map 1:a:0\
  -shortest\
  out.mp4

# cleanup the tempfiles
rm -f image.gif audio.m4a video-no-audio.mp4 intermediate.mp4
