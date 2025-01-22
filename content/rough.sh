thumbnails=$(find ./sample-csv-channel-root -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \))

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
        file="${file#./}" # removing the leading ./ from the file path
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
# has_thumbnail "$thumbnails" "html5_react"
res=$(has_thumbnail "$thumbnails" "html5_react")
if [[ "$res" != "" ]]; then
    echo "$res"
else
    echo "whoops"
fi
