#!/bin/bash

# Check if right num args provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 file1 file2"
    exit 1
fi

# Only print filename
file1="$(basename "$1")"
file2="$(basename "$2")"

# Check if files exist
if [ ! -f "$1" ]; then
    echo "File '$1' does not exist."
    exit 1
fi

if [ ! -f "$2" ]; then
    echo "File '$2' does not exist."
    exit 1
fi

# Calc hashes of each file using md5
# error out if md5 command fails
hash1=$(md5 -q "$1" 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "MD5 calculation #1 for '$file1' failed."
    exit 1
fi

hash2=$(md5 -q "$2" 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "MD5 calculation #2 for '$file2' failed."
    exit 1
fi

# Print hashes
echo "$file1: $hash1"
echo "$file2: $hash2"

# Compare hashes and set output
if [ "$hash1" == "$hash2" ]; then
    bg_color="\033[42m" # Green bg
    text="Hashes are the same "
    exit_code=0
else
    bg_color="\033[41m" # Red bg
    text="Hashes are different"
    exit_code=1
fi

# Format result output to be centered
row_length=$(tput cols)
text_length=${#text}
spaces=$(( (row_length - text_length - 1) / 2 ))

if [ $spaces -lt 0 ]; then
    spaces=0
fi

printf "${bg_color}%*s %s %*s\033[0m\n" $spaces "" "$text" $spaces ""

# Return error code
exit $exit_code
