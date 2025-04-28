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

# Manual parsing of command line options
args=("$@")  # Store all arguments in an array
i=0
non_option_args=()

# Process all arguments
while [ $i -lt $# ]; do
    arg="${args[$i]}"
    
    # Check if the argument is an option (starts with -)
    if [[ "$arg" == -* && "$arg" != "-" ]]; then
        # Check each character in the option string
        for ((j=1; j<${#arg}; j++)); do
            opt="${arg:$j:1}"  # Extract single character
            
            case "$opt" in
                n) n_flag=1 ;;
                v) v_flag=1 ;;
                *) echo -e "\x1b[1;31mError\x1b[0m: Invalid option -$opt" >&2
                   usage ;;
            esac
        done
    else
        # Not an option, add to our non-option args list
        non_option_args+=("$arg")
    fi
    
    i=$((i+1))
done

# Check if we have enough non-option arguments
if [ ${#non_option_args[@]} -lt 2 ]; then
    echo -e "\x1b[1;31mError\x1b[0m: Missing pattern or filename" >&2
    usage
elif [ ${#non_option_args[@]} -gt 2 ]; then
      echo -e "\x1b[1;31mError\x1b[0m: Too Extra arguments for my mini grep :(" >&2
      usage
fi

# Assign pattern and filename from the non-option argument list
pattern="${non_option_args[0]}"
filename="${non_option_args[1]}"

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

exit 0


