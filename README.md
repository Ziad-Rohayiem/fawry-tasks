# mygrep - A Simple Grep Implementation in Bash

A lightweight implementation of the grep command written in Bash, designed to search for patterns in text files.

## Features

- Case-insensitive search for patterns in text files
- Display line numbers for matches (`-n` option)
- Invert match to show non-matching lines (`-v` option)
- Colorized output to highlight matches
- Support for options in any position in the command line

## Installation

```bash
# Clone the repository
git clone https://github.com/Ziad-Rohayiem/fawry-tasks.git

# Make the script executable
chmod +x mygrep.sh

# Usage
./mygrep.sh [Options] pattern filename
