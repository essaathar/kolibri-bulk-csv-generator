#!/bin/bash

headers="Path *,Title *,Source ID,Description,Author,Language,License ID *,License Description,Copyright Holder,Thumbnail"
license_id="CC BY"
copyright_holder="Deaf Reach"
description=""
author="Deaf Reach"
language="en"

# Function which firstly converts all arguments to lowercase, then capitalizes first letter of each word
tc() { set ${*,,} ; echo ${*^} ; }

# Traverse over the main channel folder
for dir in */; do
    if [ -d $dir ]; then # If the main channel folder found then process it
        for content in $(find $dir | sort); do
            if [ -f $content ]; then # If a file found
                echo "FILE: $content"
                base_name=$(basename $content) # get the file name (w/ ext)
                filename="${base_name%.*}" # extract only filename
                filename=$(echo $filename | sed -r 's/[-_]+/ /g')

                processed_filename=$(tc "$filename")
                ext="${base_name##*.}"
                echo "FILE NAME: $processed_filename"
                echo -e "EXT: $ext\n"

            elif [ -d $content ]; then
                echo "DIR: $content"
                base_name=$(basename $content)
                dirname=$(echo $base_name | sed -r 's/[-_]+/ /g')
                processed_dirname=$(tc "$dirname")
                echo -e "DIR NAME: $processed_dirname\n"
                # echo $dirname | sed -r 's/[-_]+/!/g'
            fi
        done
    else # If main channel folder not found, exit
        echo "ERROR: Folder not found..."
        exit
    fi
done