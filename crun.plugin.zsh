# Function to compile and run a C file (passed as $1, e.g., myprogram.c or /tmp/myprogram.c)
# Additional arguments ($2, $3, ...) are passed to the compiled program.
crun() {
    # Check if a C filename argument was provided
    if [ -z "$1" ]; then
        echo "Usage: crun <filename.c> [args_for_program...]"
        # Example: crun myprogram.c arg1 arg2
        return 1 # Return an error code
    fi
    local c_file="$1"
    # Check if the provided argument is likely a C file and exists
    # Using [[ ]] which is generally preferred in Zsh/Bash
    if [[ ! "$c_file" == *.c || ! -f "$c_file" ]]; then
        echo "Error: File '$c_file' not found or doesn't end with .c"
        return 1 # Return an error code
    fi

    # Extract just the filename without the path and extension
    # This handles both simple filenames and full paths
    local base_filename=$(basename "$c_file")
    local output_file="${base_filename%.c}"

    # If there was a directory in the original path, use the same directory for output
    if [[ "$c_file" == */* ]]; then
        local dir_path=$(dirname "$c_file")
        output_file="$dir_path/$output_file"
    fi

    # Remove the C filename ($1) from the list of arguments.
    # After this, "$@" will contain only the arguments intended
    # for the compiled C program.
    shift

    # Compile the program. Add common warning flags. Use quotes for safety.
    echo "Compiling: gcc \"$c_file\" -o \"$output_file\" -Wall -Wextra -std=c23"
    gcc "$c_file" -o "$output_file" -Wall -Wextra -std=c23 && {
        # If compilation succeeds (&&), run the program.
        # Pass the remaining arguments ("$@") to the C program.
        # Quotes around "$@" are crucial to handle arguments with spaces correctly.
        # Don't add ./ prefix if the path is already absolute
        if [[ "$output_file" == /* ]]; then
            if [ $# -eq 0 ]; then
                echo "Running: \"$output_file\""
            else
                echo "Running: \"$output_file\" \"$@\""
            fi
            "$output_file" "$@"
        else
            if [ $# -eq 0 ]; then
                echo "Running: ./\"$output_file\""
            else
                echo "Running: ./\"$output_file\" \"$@\""
            fi
            ./"$output_file" "$@"
        fi
    }
    # The exit status of this function will be the exit status of the last command run
    # (either gcc if it failed, or the compiled program if it ran).
}
