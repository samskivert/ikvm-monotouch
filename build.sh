#!/bin/sh

set -e

export PKG_CONFIG_PATH=/Library/Frameworks/Mono.framework/Versions/Current/lib/pkgconfig
nant -t:mono-4.5
