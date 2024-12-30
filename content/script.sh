#!/bin/bash

headers="Path *,Title *,Source ID,Description,Author,Language,License ID *,License Description,Copyright Holder,Thumbnail"
license_id="CC BY"
copyright_holder="My Organization"
description="Put folder description here"
author="My Organization"
language="en"

# Function which firstly converts all arguments to lowercase, then capitalizes first letter of each word
tc() {
    set ${*,,}
    echo ${*^}
}
# Credits: https://stackoverflow.com/questions/42925485/making-a-script-that-transforms-sentences-to-title-case

# Extended functionality to remove conjuctions, prepositions, and articles
title_case() {
    set ${*,,} # convert all args to lowercase
    set ${*^} # capitalize first letter of each word
    echo -n "$1 "
    shift 1
    for f in ${*}; do
        case $f in A | An | And | As | At | But | By | For | In | Nor | Of | On | Or | So | The | To | Up | Yet)
            echo -n "${f,,} "
            ;;
        *) echo -n "$f " ;;
        esac
    done
    echo
}
# Credits: https://stackoverflow.com/questions/42925485/making-a-script-that-transforms-sentences-to-title-case

i=0
content_csv="out_Content.csv"
# clear the contents of the content.csv file, if it exists
if [ -f $content_csv ]; then
    truncate -s 0 $content_csv
fi

# write the headers
echo $headers >> $content_csv

# traverse over the main channel folder
for dir in */; do
    if [ -d $dir ]; then # if the main channel folder found then process it
        for content in $(find $dir | sort); do
            if [ -f $content ]; then # if a file found
                echo "FILE: $content"
                base_name=$(basename $content)                    # get the file name (w/ ext)
                filename="${base_name%.*}"                        # extract only filename
                filename=$(echo $filename | sed -r 's/[-_]+/ /g') # remove any hyphens/underscores

                processed_filename=$(title_case "$filename")
                ext="${base_name##*.}"
                echo "FILE NAME: $processed_filename"
                echo -e "EXT: $ext\n"

            elif [ -d $content ]; then
                echo "DIR: $content"
                base_name=$(basename $content)                    # get the dir name
                dirname=$(echo $base_name | sed -r 's/[-_]+/ /g') # remove any hyphens/underscores
                processed_dirname=$(title_case "$dirname")
                echo -e "DIR NAME: $processed_dirname\n"
            fi
            ((i++))
        done
    else # if main channel folder not found, exit
        echo "ERROR: Folder not found..."
        exit
    fi
done
