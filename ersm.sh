#!/bin/bash
#
# a simple command line elden ring save manager for systems with a normal command shell
#
# run with no arguments to get the usage instructions

ESRMDIR=$HOME/.esrm
CFGFILE=$ESRMDIR/config
SAVEDIR=$ESRMDIR/saves

function usage {
    cat >&2 <<EOF
esrm.sh <command> <args>

where command is one of

scan: attempts to find the current elden ring save on your system
configure <path-to-your-save-game>: configures your elden ring current save location
list [<category>]: lists stored elden ring saves, in the named category if given
store <category> <name>: stores current elden ring save under the given category and name
describe <category> <name>: edits the description of the save if needed
restore <category> <name>: restores the given save to elden ring
remove <category> <name>: removes the given save

as an example, consider quitting out and storing your save before a boss fight with

  esrm.sh store test i-will-probably-fuck-up-now

return to game, fuck up the boss fight, quit out, restore with

  esrm.sh restore test i-will-probably-fuck-up-now

then try again, fail again, fail better.

EOF
    exit 1
}

function scan_for_er {
    find -L $HOME/.steam/steam/steamapps/ -xdev -name 'ER0000.sl2' 2>/dev/null
}

function config {
    LOCATION="$1"
    if [ -z "$LOCATION" ]; then
        usage
    fi
    echo >$CFGFILE "$LOCATION"
    echo "configured your save game location"
}

function read_config {
    if [ ! -f "$CFGFILE" ]; then
        echo >&2 "you need to configure your save game location first"
        exit 1
    fi
    SAVELOC=`cat "$CFGFILE"`
    if [ -z "$SAVELOC" ]; then
        echo >&2 "you need to configure your save game location first"
        exit 1
    fi
    if [ ! -f "$SAVELOC" ]; then
        echo >&2 "can not find your save game at the configured location: $SAVELOC"
        exit 1
    fi
}

function list_saves {
    CAT="$1"
    for C in `ls "$SAVEDIR"`; do
        if [ ! -d "$SAVEDIR/$C" ]; then
            continue
        fi
        if [ "$CAT" -a "$C" != "$CAT" ]; then
            continue
        fi
        for S in `ls "$SAVEDIR/$C"`; do
            ls -l "$SAVEDIR/$C/$S"
        done
    done
}

function store_save {
    CAT="$1"
    SAVE="$2"
    if [ -z "$CAT" -o -z "$SAVE" ]; then
        usage
    fi
    mkdir -p "$SAVEDIR/$CAT"
    if cp "$SAVELOC" "$SAVEDIR/$CAT/$SAVE"; then
        echo "current save is now safely stored"
    else
        echo "failed to store your current save"
        exit 1
    fi
}

function restore_save {
    CAT="$1"
    SAVE="$2"
    if [ ! -f "$SAVEDIR/$CAT/$SAVE" ]; then
        echo >&2 "no such save game exists"
        exit 1
    fi
    # TODO check if the file specified really looks like an elden ring save
    if cp "$SAVEDIR/$CAT/$SAVE" "$SAVELOC"; then
        echo "restored your current save"
    else
        echo "failed to restore your current save"
        exit 1
    fi
}

function remove_save {
    CAT="$1"
    SAVE="$2"
    if [ ! -f "$SAVEDIR/$CAT/$SAVE" ]; then
        echo >&2 "no such save game exists"
        exit 1
    fi
    if rm "$SAVEDIR/$CAT/$SAVE"; then
        echo "removed the save"
    else
        echo "failed to remove the save"
        exit 1
    fi
}

function describe_save {
    echo "not implemented"
    exit 1
}

CMD="$1"
shift
ARGS="$@"

if [ -z "$CMD" ]; then
    usage
fi

mkdir -p $ESRMDIR
mkdir -p $SAVEDIR

case $CMD in
    scan)
        scan_for_er
        exit 0
        ;;
    
    configure)
        config "$1"
        exit 0
        ;;
esac

read_config

case $CMD in
    list)
        list_saves "$1"
        exit 0
        ;;

    store)
        store_save "$1" "$2"
        exit 0
        ;;
    
    restore)
        restore_save "$1" "$2"
        ;;

    describe)
        describe_save "$1" "$2"
        ;;

    remove)
        remove_save "$1" "$2"
        ;;
esac

exit 0
