#!/bin/sh

set -e

export PKG_CONFIG_PATH=/Library/Frameworks/Mono.framework/Versions/Current/lib/pkgconfig
nant phase1
nant -t:moonlight-2.0 phase2
nant phase3
nant -t:moonlight-2.0 phase4
nant phase5
