#!/usr/bin/env bash

# genman.sh
# This is a script for Debian packagers,
# to generate man files from executables' --help options,
# using help2man.
# Tested on Dash, should work with other POSIX shells.
# Version 20220126

#    Copyright (C) 2018-2022  John Crawley <john@bunsenlabs.org>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Put this script in the package source debian/ directory
# (or some other location, to taste),
# add a file debian/genman-list, debian/<packagename>.genman-list
# or debian/<packagename>.<section-number>.genman-list
# with a list of the executables whose manpages are to be built.
# Shell globs may be used.
# If set, <section-number> determines the manual section,
# otherwise section 1 is used by default.
# Multiple genman-list files can be used, for source building
# multiple packages, or for different manual sections.
#
# Built manpages will be put in debian/genman-pages/, and
# their paths will be appended to an existing debian/*manpages file,
# or put in a new manpages or <packagename>.manpages file.
#
# see genman.sh --help for more info.
#
# Run the script manually before building the package,
# or to auto-run, add this to debian/rules:
# (adjust the path to genman.sh if necessary)
###
#override_dh_installman:
#	debian/genman.sh
#	dh_installman
#
#override_dh_clean:
#	dh_clean
#	debian/genman.sh --clean
#
# Also add help2man to Build-Depends in debian/control.

########################################################################


# https://github.com/BunsenLabs/bunsen-utilities


set -e


# Internationalize the genman.sh script

TEXTDOMAIN="genman"
# TEXTDOMAINDIR="/usr/share/locale"
TEXTDOMAINDIR="locale"

export TEXTDOMAIN TEXTDOMAINDIR


if ! command -v yad &> /dev/null; then

  echo -e "\nThe yad program is not installed.\n"

  exit 1

fi

logo="/usr/share/icons/Bunsen-lightdm/256x256/status/avatar-default.png"

which gettext        1> /dev/null 2> /dev/null || { yad \
--center \
--window-icon "$logo" \
--image=dialog-error \
--timeout=10 \
--no-buttons \
--title "Warning" \
--text "The gettext program is not installed." \
--width="450" --height="100" \
2>/dev/null   ; exit ; }


for cmd in sed help2man dpkg-parsechangelog ; do

    if ! command -v "${cmd}" >/dev/null 2>&1; then
        yad \
            --center \
            --window-icon "$logo" \
            --image=dialog-error \
            --timeout=10 \
            --no-buttons \
            --title "$(gettext "Warning")" \
            --text "$(printf '%s\n' \
                "$(gettext "The following required program is not installed: ")
" \
                "${cmd}")" \
            --width="450" \
            --height="100" \
            2>/dev/null

        # exit 1
    fi

done


src_name=$(dpkg-parsechangelog -S Source) || {

    printf "\n$(gettext "%s: Not in debian source directory?")\n" "$0" >&2

    exit 1
}
pkg_name="$src_name" # will be replaced if <packagename>.*.genman-list found
pkg_ver=$(dpkg-parsechangelog -S Version)
# default if genman-list file has no digit in name
default_section=1

# BunsenLabs generic content
# Other vendors, please edit to taste.

includes="[author]
Written by the BunsenLabs team.

[reporting bugs]
Please report bugs at:

https://github.com/BunsenLabs/${src_name}/issues

[see also]
The BunsenLabs forums may be able to answer your questions:

https://forums.bunsenlabs.org
"

HELP="$(gettext "genman.sh is a wrapper script round 'help2man'
to generate man pages for debian packages.

Usage: genman.sh [OPTIONS] [file]

This is a script for debian packagers, which automates the generation
of simple man pages from the output of executables' \"--help\" options,
along with information from dpkg, and configuration files
in the package source debian/ directory.

Arguments:

    <no arguments>
            Generate the necessary files in the source directory.

    --clean
            Return everything in the package debian/ directory
            to the state it was in before running the script.

    --test <executable>
            Display the manpage that would be generated for this file.
            Nothing is changed in the source directory.

    --makeone <executable>
            Generate a single man file for this one executable and
            place it in the working directory (package source root).
            (You will still need to add it to debian/<package>.manpages.)

    -h --help
            Show this message.


Configuration:

    The script will look for files in debian/

        <packagename>.<section>.genman-list

        <packagename>.genman-list

        genman-list

    If <section> ([1-8]) is missing, assume 1.

    If <packagename> is also missing, get from dpkg.

    The genman-list file should have a list of the executables
    (paths relative to the package root) whose manpages are to be built.
    Shell globs may be used.
    Multiple genman-list files can be used, for source building
    multiple packages, or for different manual sections.

Built manpages will be put in debian/genman-pages/, and
their paths will be appended to an existing debian/*manpages file,
or put in a new manpages or <packagename>.manpages file.

The script can be located anywhere, but should be run
from the package source root directory.
Run it manually before building the package,
or to auto-run, add this to debian/rules:
(adjust the path to genman.sh if necessary)

override_dh_installman:

<tab>debian/genman.sh

<tab>dh_installman

override_dh_clean:

<tab>dh_clean

<tab>debian/genman.sh --clean

Also add help2man to Build-Depends in debian/control.
")"

### it may not be necessary to edit below this line ###

include_file=debian/genman.include

### functions ###

# pass file with list of executables to make manpages for,
# with file or shell glob on each line

build_mans() (
    while read -r line
    do
        [ -f "$line" ] && {
            mk_man "$line"
            continue
        }
        for file in $line # shell glob
        do
            [ -f "$file" ] || continue
            mk_man "$file"
        done
    done < "$1"
)

# pass "executable" file (it need not actually be executable in the source)

mk_man() (
    exec="$1"
    cmd=${1##*/}
    manfile="${manpg_dir}/${cmd}.${section}"
    execflag=false
    mkdir -p "$manpg_dir"
    grep "${cmd}\(.[1-8]\)\? *\$" "${manpages_file}" >/dev/null 2>&1 && {

        printf "\n$(gettext "%s: %s already in %s, skipping")\n" "$0" "${cmd}" "${manpages_file}"

        return 0
    }
    [ -x "$exec" ] && execflag=true
    [ "$execflag" = false ] && chmod +x "$exec"

    default_desc="$(printf "$(gettext "a script provided by %s")" "${pkg_name}")"

    desc="$( ./"$exec" --help 2>&1 | sed -rn "/^ *$cmd/ {s/^ *$cmd( -|:| is)? *//p;q}")"
    [ -z "$desc" ] && desc="$default_desc"
    help2man ./"$exec" --no-info --no-discard-stderr --version-string="$cmd $pkg_ver" --section="$section" --name="$desc" --include="$include_file" | sed "s|$HOME|~|g" > "$manfile"
    [ "$execflag" = false ] && chmod -x "$exec"
    echo "$manfile" >> "${manpages_file}"
)

# pass "executable" file
# output is piped to 'man -l -' for inspection
# or by --create option to make single file in current directory

test_man() (
    createflag=false
    [ "$1" = '--create' ] && {
        createflag=true
        shift
    }
    exec="$1"
    cmd=${1##*/}
    manfile=./"${cmd}.${section}"
    execflag=false
    [ -x "$exec" ] && execflag=true
    [ "$execflag" = false ] && chmod +x "$exec"

    default_desc="$(printf "$(gettext "a script provided by %s")" "${pkg_name}")"

    desc="$( ./"$exec" --help 2>&1 | sed -rn "/^ *$cmd/ {s/^ *$cmd( -|:| is)? *//p;q}")"
    [ -z "$desc" ] && desc="$default_desc"
    if [ "$createflag" = false ]
    then
        help2man ./"$exec" --no-info --no-discard-stderr --version-string="$cmd $pkg_ver" --section="$section" --name="$desc" --include="$include_file" | sed "s|$HOME|~|g" | man -l -
    else
        help2man ./"$exec" --no-info --no-discard-stderr --version-string="$cmd $pkg_ver" --section="$section" --name="$desc" --include="$include_file" | sed "s|$HOME|~|g" > "$manfile"
    fi
    [ "$execflag" = false ] && chmod -x "$exec"
)

### script starts here ###

case $1 in
--clean)
    rm -rf debian/*genman-pages

    # avoid cleaning existing files

    [ -f "$include_file" ] && rm -f debian/*manpages
    rm -f "$include_file"
    for i in debian/*.genman.bckp # restore backups
    do
        [ -f "$i" ] || continue
        mv "$i" "${i%.genman.bckp}"
    done
    exit 0
    ;;
--test)
    [ -n "$2" ] || { echo -e "\n$(gettext "Please pass a file to test.")\n" >&2; exit 1;}
    section="$default_section"
    include_file="$(mktemp)"
    cat <<EOF > "$include_file"
$includes
EOF
    test_man "$2"
    rm -f "$include_file"
    exit
    ;;
--makeone)
    [ -n "$2" ] || { echo -e "\n$(gettext "Please pass a file to make a manpage for.")\n" >&2; exit 1;}
    section="$default_section"
    include_file="$(mktemp)"
    cat <<EOF > "$include_file"
$includes
EOF
    test_man --create "$2"
    rm -f "$include_file"
    exit
    ;;
--help|-h)
    echo "$HELP"
    exit 0
    ;;
'')
    ;;
*)

    printf "$(gettext "%s: ERROR %s: no such option")" "${0}" "\"${1}\"" >&2

    echo
    echo "$HELP"
    exit 1
    ;;
esac

# avoid multiple runs

[ -f "$include_file" ] && {

    printf "$(gettext "%s: manpages already built")" "$0" >&2

    exit 1
}

# backup any existing manpages files

for file in debian/*manpages
do
    [ -f "$file" ] || continue
    cp "$file" "$file".genman.bckp
done

cat <<EOF > "$include_file"
$includes
EOF

for list in debian/*.genman-list
do
    [ -f "$list" ] || continue
    found_list=true
    pkg_name="${list##*/}"
    pkg_name="${pkg_name%.genman-list}"

# If filename is <package>.[1-9].genman-list
# then digit determines section, otherwise use default set above.

    case $pkg_name in
    *.[1-8])
        section="${pkg_name##*.}"
        pkg_name="${pkg_name%.*}"
        ;;
    *)
        section="$default_section"
        ;;
    esac
    manpages_file=debian/${pkg_name}.manpages
    manpg_dir=debian/${pkg_name}.genman-pages
    build_mans "$list"
done

# simple option

if [ "$found_list" != true ] && [ -f debian/genman-list ]
then
    section="$default_section"
    manpages_file=debian/manpages
    manpg_dir=debian/genman-pages
    build_mans debian/genman-list
fi

