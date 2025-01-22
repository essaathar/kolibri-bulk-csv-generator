#!/bin/bash

# CONSTANTS
headers="Path *,Title *,Source ID,Description,Author,Language,License ID *,License Description,Copyright Holder,Thumbnail"
license_id="CC BY"
copyright_holder="Deaf Reach"
description="Put folder description here"
author="Deaf Reach"
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
    set ${*^}  # capitalize first letter of each word
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

# This function checks if the given dir/file has a corresponding thumbnail
# Arguments:
# List of thumbnails gotten through the `find` command
# Dir/File name to match
# Output:
# "yes" if a match is found
has_thumbnail() {
    declare -A dict

    # convert the thumbnails to a hash table where key = file name and value = file path
    thumbnails=$1
    for file in $thumbnails; do
        file="${file#./}"           # removing the leading ./ from the file path
        base_name=$(basename $file) # get the file name (w/ ext)
        filename_without_ext="${base_name%.*}"
        filename_without_thumb="${filename_without_ext%-thumb}"
        dict["$filename_without_thumb"]=$file
    done

    result=""
    dirname="$2"
    # echo "dirname: $dirname"
    for key in "${!dict[@]}"; do
        # echo "KEY: $key, VALUE: ${dict[$key]}"
        if [[ "$key" == "$dirname" ]]; then
            result="${dict[$key]}"
            # echo "yes"
            break
        fi
    done
    echo "$result"
}

i=0
content_csv="out_Content.csv"
# clear the contents of the content.csv file, if it exists
if [ -f $content_csv ]; then
    truncate -s 0 $content_csv
fi

# write the headers
echo $headers >>$content_csv

current_dir="" # temporary var to keep track

# get all thumbnails
thumbnails=$(find . -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \))

# echo "THUMBNAILS: $thumbnails"

# traverse over the main channel folder
for dir in */; do
    if [ -d $dir ]; then # if the main channel folder found then process it
        for content in $(find $dir | sort); do
            # skip if an image (thumbnail) found
            if [[ -f "$content" && ("$content" == *.jpg || "$content" == *.jpeg || "$content" == *.png) ]]; then
                continue
            
            elif [ -f $content ]; then # if a file (content node) is found
                echo "FILE: $content"
                base_name=$(basename $content) # get the file name (w/ ext)
                filename="${base_name%.*}"     # extract only filename (w/o ext)
                echo -e "FILE NAME: $filename\n"
                processed_filename=$(echo $filename | sed -r 's/[-_]+/ /g') # remove any hyphens/underscores

                processed_filename=$(title_case "$processed_filename")
                ext="${base_name##*.}"
                echo "FILE NAME: $processed_filename"
                echo -e "EXT: $ext\n"

                row="$content,$processed_filename,$i,$description,$author,$language,$license_id,$license_description,$copyright_holder,"
                has_thumbnail_result=$(has_thumbnail "$thumbnails" "$filename")
                if [[ $has_thumbnail_result != "" ]]; then
                    echo -e "has_thumbnail_result: $has_thumbnail_result\n"
                    row="$row$has_thumbnail_result"
                fi

                echo $row >>$content_csv
                # has_thumbnail_result=$(has_thumbnail "$thumbnails" "$filename")
                # echo -e "has_thumbnail_result: $has_thumbnail_result\n"

            elif [ -d $content ]; then
                echo "DIR: $content"
                base_name=$(basename $content) # get the dir name
                echo -e "DIR NAME: $base_name\n"
                dirname=$(echo $base_name | sed -r 's/[-_]+/ /g') # remove any hyphens/underscores
                processed_dirname=$(title_case "$dirname")
                echo -e "DIR NAME: $processed_dirname\n"

                row="$content,$processed_dirname,$i,$description,$author,$language,,,$copyright_holder,"
                has_thumbnail_result=$(has_thumbnail "$thumbnails" "$base_name")
                if [[ $has_thumbnail_result != "" ]]; then
                    row="$row$has_thumbnail_result"
                fi

                echo $row >>$content_csv

            fi
            ((i++))
        done
    else # if main channel folder not found, exit
        echo "ERROR: Folder not found..."
        exit
    fi
done
