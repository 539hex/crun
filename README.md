# Crun - Shell plugin to compile and run .c files

A convenient shell plugin that streamlines the process of compiling and running C programs in a single command.

## Overview

`crun` is a shell plugin that simplifies the C development workflow by combining compilation and execution into a single command. It automatically handles file paths, applies recommended compiler warnings, uses modern C standards, and passes any additional arguments to your program.

## Features

- **One-step compile and run** - No need for separate compilation and execution commands
- **Multiple source file support** - Easily compile a main file with multiple library source files
- **Automatic output naming** - Executable name is derived from the main source file
- **Path preservation** - Maintains the same directory structure for output files
- **Modern C standards** - Compiles with C23 standard by default
- **Developer-friendly warnings** - Automatically adds `-Wall` and `-Wextra` compiler flags
- **Argument passing** - Seamlessly forwards command line arguments to your program
- **Informative output** - Shows compilation and execution commands for transparency
- **Error handling** - Provides helpful error messages for common issues

## Installation

Add the `crun` function to your shell configuration file (`.bashrc`, `.zshrc`, etc.).

## Usage

### Basic Usage

```bash
crun myprogram.c
```

This will compile `myprogram.c` into an executable named `myprogram` and then run it.

### Compiling with Library Source Files

```bash
crun myprogram.c utils.c math.c
```

This will compile `myprogram.c` together with the library source files `utils.c` and `math.c`, create an executable named `myprogram`, and then run it.

### Passing Arguments to Your Program

```bash
crun myprogram.c utils.c arg1 arg2 "argument with spaces"
```

The arguments `arg1`, `arg2`, and `argument with spaces` will be passed to your program after it's compiled.

### Working with Different Paths

```bash
crun ~/projects/c/hello.c ~/libs/utils.c
```

This will compile `~/projects/c/hello.c` with `~/libs/utils.c` and create the executable in the same directory as the main file (`~/projects/c/hello`).

### Argument Order Matters

All `.c` files that appear before the first non-`.c` argument are treated as source files to compile. Once a non-`.c` argument is encountered, all remaining arguments (even if they end with `.c`) are passed to the compiled program.

```bash
# utils.c and math.c are compiled, data.txt and test.c are program arguments
crun main.c utils.c math.c data.txt test.c
```



## Compatibility

This function works in Bash and Zsh shells. It requires `gcc` to be installed and available in your PATH.