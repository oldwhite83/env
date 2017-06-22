#!/usr/bin/env bash

# speed up make
CPUS=$(getconf _NPROCESSORS_ONLN)
MAKETHREADS=" -j $CPUS"
