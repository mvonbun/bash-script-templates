#!/usr/bin/env bash

### parameter parsing
HELP=false
VERBOSE=false
QUIET=false
DRYRUN=false
# switch parameters
SWITCH=false
# mandatory
MAN=true
# optional (with default)
#   short option syntax: -o [val]
#   long option syntax:  --opt[=val]
OPT=false
OPTVAL=DEFAULT
# multiple mandatory space seperated and saved in list
LIST=false
LISTVAL=()

eval set -- $ARGS
while [ $# -gt 0 ]; do
    case "$1" in
        -h | --help)
	    HELP=true;;
	-q | --quiet)
	    QUIET=true;;
        -v | --verbose)
	    VERBOSE=true;;
	-n | --dry)
	    DRYRUN=true;;
	# switch option
        -s | --switch)
	    SWITCH=true;;
	# mandatory
	-m | --mandatory)
	    MAN=true;
	    MANVAL="$2"; shift;;
	# optional (with default)
	-o | --optional)
	    OPT=true;
	    if [ "$1" = "-o" ]; then
		if [[ "$2" != -* ]]; then
		    OPTVAL="$2"; shift
		fi ;;
	    else
		if [[ "$2" = "="* ]]; then
		    OPTVAL="$2"; shift
		fi ;;
	    fi ;;
	# multiple mandatory
	-l | --list)
	    LIST=true; LISTVAL=("${LISTVAL[@]}" "$2"); shift;;
        --)
	    shift; break;; # end of options
    esac
    shift
done

### help text
if [ "$HELP" = true ]; then
    echo "$thisScriptBasename [options] argument list"
    echo ""
    echo "Options:"
    echo ""
    echo "   -h/--help              show this help text"
    echo "   -q/--quiet             disable basic status messages"
    echo "   -v/--verbose           enable verbosity"
    echo "   -n/--dry               dry run"
    echo ""
    echo "   -s/--switch            a simple switch"
    echo "   -m/--mandatory         needs mandatory argument"
    echo "   -o [val]/--opt[=val]   needs optional argument"
    echo "   -l/--list              add multiple calls of -l to a list"
    echo ""
    exit
fi

### set user notification levels
# verbosity
if [ "$VERBOSE" = true ]; then
    V=/dev/stdout
else
    V=/dev/null
fi
# quiet
if [ "$QUIET" = true ]; then
    Q=/dev/null
else
    Q=/dev/stdout
fi
# dry run
if [ "$DRYRUN" = true ]; then
    Q=/dev/stdout
fi
# basic command line notification
echo "*** Script Identification" &>$Q
if [ "$DRYRUN" = true ]; then
    echo "***        DRY * RUN         ***" &>$Q
fi

# verbose message
echo "I am going to start this nice script" &>$V

### remaining parameter processing
## procedure if all parameters are treated the same way
# aka: do for every parameter
if [ $# -gt 0 ]; then

    for ARG in "$@"; do

	echo "Do something with $ARG"
	echo "Done." &>$Q

	# file splitting: full paths
	INPATH=$(cd "$(dirname "$ARG")"; pwd)
	INFILE=${ARG##*/}
	# [[ "$ARG" == */* ]] || ARG="./$ARG"
	# [[ "$ARG" == */* ]] || ARG=$(pwd)/"$ARG"
	# ARGPATH=${ARG%/*}
	# ARGPATH=${ARG%/*}
	# ARGFILE=${ARG##*/}
	
    done
fi
