#!/usr/bin/env bash
#
# Template script
#

# resources
# http://www.bahmanm.com/blogs/command-line-options-how-to-parse-in-bash-using-getopt
# http://stackoverflow.com/questions/2721946/cross-platform-getopt-for-a-shell-script

### get script names
thisScript=${0##*/}
thisScriptBasename=${thisScript%%.*} # PROG=`basename $0`
thisScriptExtension=${thisScript##*.}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CALLERDIR="$(pwd)"

# if [ "$a" != "$b" ]; then
#     echo "$thisScriptBasename: warning script was called from" >&2
#     echo "   $CALLERDIR (should be $DIR)" >&2
#     echo "   Relative paths might not work as intendend!" >&2
# fi

### test for GNU getopt
getopt -T > /dev/null
if [ $? -eq 4 ]; then
    # GNU enhanced getopt is available
    # getopt parse string
    # --long    >> comma seperated list of long option names
    # --options >> list of short option characters
    # :         >> option has a mandatory argument
    # ::        >> option has an optional argument
    #
    # option passing
    # type  | switch | mandatory               | optional
    # short | -a     | -a name                 | -aname
    # long  | -alpha | -alpha name -alpha=name | -aplha=name
    ARGS=`getopt --name "$thisScriptBasename" --long help,quiet,verbose,dry,switch,mandatory:,optional::,list: --options hnqvsm:o::l: -- "$@"`
else
    echo "$thisScriptBasename: error GNU getopt not available" >&2
    exit 2
#   # Use builtin getopts instead (no long option names)
#   ARGS=`getopts ho:v "$@"`
fi

### no arguments provided
if [ $? -ne 0 ]; then
  echo "$thisScriptBasename: usage error (use -h for help)" >&2
  exit 2
fi

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
# multiple mandatory: save in list
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
            case "$2" in
                "")
		    OPTVAL='some default value'; shift;;
                *)
		    OPTVAL=$2; shift;;
            esac ;;
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
    echo "$thisScriptBasename [options] package-name"
    echo ""
    echo "Options:"
    echo ""
    echo "   -h/--help         show this help text"
    echo "   -q/--quiet        disable basic status messages"
    echo "   -v/--verbose      enable verbosity"
    echo "   -n/--dry          dry run"
    echo ""
    echo "   -m/--mandatory    needs mandatory argument"
    echo "   -o/--optional     needs optional argument"
    echo "   -s/--switch       acts as a switch only"
    echo "   -l/--list         add multiple calls of -l to a list"
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

## procedure for different kinds of parameters
if [ $# -gt 0 ]; then
    if [ $# -eq 1 ]; then
	echo "Do something with $1"
    fi
    if [ $# -eq 2 ]; then
	echo "Do something with $2"
    fi    
fi


## tool checking
type toolname >/dev/null 2>&1 || { echo >&2 "I require toolname but it's not installed. Aborting."; exit 1;}
type toolname >/dev/null 2>&1 && { echo >&2 "toolname is installed. Continuing.";}


