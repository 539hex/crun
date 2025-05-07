# Function to compile and run a C file (passed as $1, e.g., myprogram.c or /tmp/myprogram.c)
# Any additional .c files are added to compilation as libraries
# All other arguments are passed to the compiled program.
crun() {
    # Check if a C filename argument was provided
    if [ -z "$1" ]; then
        echo "Usage: crun <main_file.c> [library1.c library2.c ...] [args_for_program...]"
        # Example: crun myprogram.c lib1.c lib2.c arg1 arg2
        return 1 # Return an error code
    fi
    
    local c_file="$1"
    
    # Check if the provided argument is likely a C file and exists
    # Using [[ ]] which is generally preferred in Zsh/Bash
    if [[ ! "$c_file" == *.c || ! -f "$c_file" ]]; then
        echo "Error: Main file '$c_file' not found or doesn't end with .c"
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
    
    # Remove the main C file from the arguments
    shift
    
    # Initialize compiler command with the main file
    local compile_cmd="gcc \"$c_file\""
    local lib_files=()
    local prog_args=()
    local found_non_c_file=0
    
    # Process remaining arguments
    for arg in "$@"; do
        if [[ "$arg" == *.c ]]; then
            # If we've already seen a non-.c file, treat this as a program argument
            if (( found_non_c_file )); then
                prog_args+=("$arg")
            else
                # Check if the library file exists
                if [[ ! -f "$arg" ]]; then
                    echo "Error: Library file '$arg' not found"
                    return 1
                fi
                compile_cmd="$compile_cmd \"$arg\""
                lib_files+=("$arg")
            fi
        else
            found_non_c_file=1
            prog_args+=("$arg")
        fi
    done
    
    # Build the compile command with output and flags
    compile_cmd="$compile_cmd -o \"$output_file\" -Wall -Wextra -std=c23"
    
    # Display compilation command
    echo -n "Compiling: gcc \"$c_file\""
    for lib in "${lib_files[@]}"; do
        echo -n " \"$lib\""
    done
    echo " -o \"$output_file\" -Wall -Wextra -std=c23"
    
    # Execute compilation
    eval $compile_cmd && {
        # If compilation succeeds (&&), run the program.
        # Don't add ./ prefix if the path is already absolute
        if [[ "$output_file" == /* ]]; then
            if [ ${#prog_args[@]} -eq 0 ]; then
                echo "Running: \"$output_file\""
                "$output_file"
            else
                echo -n "Running: \"$output_file\""
                for arg in "${prog_args[@]}"; do
                    echo -n " \"$arg\""
                done
                echo
                "$output_file" "${prog_args[@]}"
            fi
        else
            if [ ${#prog_args[@]} -eq 0 ]; then
                echo "Running: ./\"$output_file\""
                ./"$output_file"
            else
                echo -n "Running: ./\"$output_file\""
                for arg in "${prog_args[@]}"; do
                    echo -n " \"$arg\""
                done
                echo
                ./"$output_file" "${prog_args[@]}"
            fi
        fi
    }
    # The exit status of this function will be the exit status of the last command run
    # (either gcc if it failed, or the compiled program if it ran).
}