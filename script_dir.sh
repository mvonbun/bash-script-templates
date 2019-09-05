#!/usr/bin/env bash
### get script names and directories
script_=${0##*/}
script_base=${script_%%.*} # PROG=`basename $0`
script_ext=${script_##*.}	# 
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
caller_dir="$(pwd)"

