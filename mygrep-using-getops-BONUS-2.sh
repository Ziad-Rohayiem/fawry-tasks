#!/bin/bash

# Initialize variables
n_flag=0
v_flag=0
pattern=""
filename=""

# Function to display usage information
usage() {
    echo "Usage: $0 [OPTIONS] PATTERN FILE"
    echo "Options:"
    echo "  -n    Show line numbers for each match"
    echo "  -v    Invert the match (print lines that do not match)"
    exit 1
}

# Parse command line options usning getops
while getopts "nv" opt; do
    case $opt in
        n) n_flag=1 ;;
        v) v_flag=1 ;;
        *) usage ;;
    esac
done

# Adjust position parameters
shift $((OPTIND-1))

# Check if we have enough arguments
if [ $# -lt 2 ]; then
    echo -e "\x1b[1;31mError\x1b[0m: Missing pattern or filename" >&2
    usage
elif [ $# -gt 2 ]; then
      echo -e "\x1b[1;31mError\x1b[0m: Too Extra arguments for my mini grep :(" >&2
      usage
fi

pattern="$1"
filename="$2"

# Check if file exists
if [ ! -f "$filename" ]; then
    echo -e "\x1b[1;31mError\x1b[0m: File '$filename' does not exist" >&2
    exit 1
fi

# Process the file line by line
line_number=0
while IFS= read -r line; do
    line_number=$((line_number + 1))
    
    # Perform case-insensitive match
    if [[ "${line,,}" == *"${pattern,,}"* ]]; then
        pattern_found_flag=1
    else
        pattern_found_flag=0
    fi
    
    # Determine whether to print based on invert flag
    if [ $v_flag -eq 0 -a $pattern_found_flag -eq 1 ] || [ $v_flag -eq 1 -a $pattern_found_flag -eq 0 ]; then
	# Highlight the matched pattern in red
	highlighted_line=$(echo "$line" | sed -E "s/(${pattern})/\x1b[1;33m\1\x1b[0m/Ig")
        if [ $n_flag -eq 1 ]; then
            echo "$line_number:$highlighted_line"
        else
            echo "$highlighted_line"
        fi
    fi
done < "$filename"

exit

