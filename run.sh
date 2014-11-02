#!/bin/sh

COMMAND=/bin/bash

xhost + # allow connections to X server
docker run --privileged -e "DISPLAY=unix:0.0" -v="/tmp/.X11-unix:/tmp/.X11-unix:rw"  -d -p 127.0.0.1:2222:22 steam
