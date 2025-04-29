# crun - Shell plugin to compilen and run .c files

A convenient shell plugin that streamlines the process of compiling and running C programs in a single command.

## Overview

`crun` is a shell plugin that simplifies the C development workflow by combining compilation and execution into a single command. It automatically handles file paths, applies recommended compiler warnings, uses modern C standards, and passes any additional arguments to your program.

## Features

- **One-step compile and run** - No need for separate compilation and execution commands
- **Automatic output naming** - Executable name is derived from the source file
- **Path preservation** - Maintains the same directory structure for output files
- **Modern C standards** - Compiles with C23 standard by default
- **Developer-friendly warnings** - Automatically adds `-Wall` and `-Wextra` compiler flags
- **Argument passing** - Seamlessly forwards command line arguments to your program
- **Informative output** - Shows compilation and execution commands for transparency
- **Error handling** - Provides helpful error messages for common issues

## Installation

Add the `crun` function to your shell configuration file (`.bashrc`, `.zshrc`, etc.):

## Usage

### Basic Usage

```bash
crun myprogram.c
```

This will compile `myprogram.c` into an executable named `myprogram` and then run it.

### Passing Arguments to Your Program

```bash
crun myprogram.c arg1 arg2 "argument with spaces"
```

The arguments `arg1`, `arg2`, and `argument with spaces` will be passed to your program after it's compiled.

### Working with Different Paths

```bash
crun ~/projects/c/hello.c
```

This will compile `~/projects/c/hello.c` and create the executable in the same directory (`~/projects/c/hello`).


## Compatibility

This function works in Bash and Zsh shells. It requires `gcc` to be installed and available in your PATH.
