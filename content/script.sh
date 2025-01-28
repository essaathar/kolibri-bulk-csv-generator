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
    
    for key in "${!dict[@]}"; do
        # echo "KEY: $key, VALUE: ${dict[$key]}"
        # if [[ "$dirname" =~ "$key" ]]; then

        if [[ "$key" == "$dirname" ]]; then
            result="${dict[$key]}"
            # echo "yes"
            break
        fi
    done

    if [[ -z $result ]]; then
        # check if similar exp found
        for key in "${!dict[@]}"; do
            # echo "KEY: $key, VALUE: ${dict[$key]}"
            if [[ "$dirname" =~ "$key" ]]; then
                result="${dict[$key]}"
                break
            fi
        done
    fi
    echo "$result"
}


i=0
content_csv="Content.csv"
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

main_channel_dir=""
# traverse over the main channel folder
for dir in */; do
    if [[ -d $dir && $(basename $dir) != ".ricecookercache" && $(basename $dir) != "chefdata" && $(basename $dir) != "logs" && $(basename $dir) != "restore" && $(basename $dir) != "storage" ]]; then # if the main channel folder found then process it
        main_channel_dir=$(basename $dir)
        # echo "dir -> $parent_dir"
        for content in $(find $dir | sort); do
            # skip if channel name dir found since that isn't included in Content.csv
            if [[ $(basename $dir) == $(basename $content) ]]; then
                continue
            # parent_dir=$(basename $dir)
            # content_dir=$(basename $content)
            # echo "parent_dir -> $parent_dir, content ->"

            # skip if an image (thumbnail) found
            elif [[ -f "$content" && ("$content" == *.jpg || "$content" == *.jpeg || "$content" == *.png) ]]; then
                continue

            elif [ -f $content ]; then # if a file (content node) is found
                echo "FILE: $content"
                base_name=$(basename $content) # get the file name (w/ ext)
                filename="${base_name%.*}"     # extract only filename (w/o ext)
                echo -e "FILE NAME: $filename\n"
                processed_filename=$(echo $filename | sed -r 's/[-_]+/ /g') # remove any hyphens/underscores

                # processed_filename=$(title_case "$processed_filename")
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
                # processed_dirname=$(title_case "$dirname")
                processed_dirname=$dirname
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
    fi
done

if [ -z $main_channel_dir ]; then
    echo "Main channel folder not found. Exiting..."
fi

# activate the kolibri ricecooker venv (optional)
if [[ -d ~/ricecooker-venv ]]; then
    # echo "venv exists"
    source ~/ricecooker-venv/bin/activate
else
    echo "no such venv"
fi

# load the env file for acccessing the Kolibri API token
source "$(dirname $0)/.env"
# echo "MY API TOKEN = $API_TOKEN"

# Run the linecook file which scans the content folder and the content and channel csvs and then uploads the channel on Kolibri, through ricecooker
python3 ../linecook.py --token=$API_TOKEN --channeldir="./$main_channel_dir"

