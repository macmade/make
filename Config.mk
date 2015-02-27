#-------------------------------------------------------------------------------
# The MIT License (MIT)
# 
# Copyright (c) 2014 Jean-David Gadina - www-xs-labs.com
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# @author           Jean-David Gadina
# @copyright        (c) 2010-2015, Jean-David Gadina - www.xs-labs.com
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# General
#-------------------------------------------------------------------------------

# Default make target
.DEFAULT_GOAL := all

# Host architecture
HOST_ARCH := $(shell uname -m)

# File extensions
EXT_H          := .h
EXT_C          := .c
EXT_CPP        := .cpp
EXT_M          := .m
EXT_O          := .o

#-------------------------------------------------------------------------------
# Paths & directories
#-------------------------------------------------------------------------------

# Project directories
DIR_SRC       := source/
DIR_INC       := include/
DIR_BUILD     := build/
DIR_BUILD_OBJ := $(DIR_BUILD)obj/
DIR_BUILD_BIN := $(DIR_BUILD)bin/

#-------------------------------------------------------------------------------
# Software
#-------------------------------------------------------------------------------

# Default shell
SHELL := /bin/bash

# Make
MAKE_VERSION_MAJOR  := $(shell echo $(MAKE_VERSION) | cut -f1 -d.)
MAKE_4              := $(shell [ $(MAKE_VERSION_MAJOR) -ge 4 ] && echo true)

MAKE := $(MAKE) -s MAKEFLAGS=

# Enables parallel execution if available
ifeq ($(MAKE_4),true)
    MAKE := $(MAKE) -j 50 --output-sync
endif

# C compiler
CC                    := clang
ARGS_CC_WARN          := -Weverything -Werror
ARGS_CC_INC           := -I $(DIR_INC)
ARGS_CC_OPTIM         := -Os
ARGS_CC_MISC          := -fno-strict-aliasing
ARGS_CC                = $(ARGS_CC_OPTIM) $(ARGS_CC_MISC) $(ARGS_CC_INC) $(ARGS_CC_WARN)

# Language specific
ARGS_CC_C             := -std=c99
ARGS_CC_CPP           := -std=c++11
ARGS_CC_M             := -std=c99

# Linker
LD                    := ld
ARGS_LD               := 

# Archiver
AR                    := ar
ARGS_AR               := rcs
RANLIB                := ranlib
ARGS_RANLIB           := 

#-------------------------------------------------------------------------------
# Display
#-------------------------------------------------------------------------------

ifndef XCODE_VERSION_MAJOR

# Colors for the terminal output
COLOR_NONE   := "\x1b[0m"
COLOR_GRAY   := "\x1b[30;01m"
COLOR_RED    := "\x1b[31;01m"
COLOR_GREEN  := "\x1b[32;01m"
COLOR_YELLOW := "\x1b[33;01m"
COLOR_BLUE   := "\x1b[34;01m"
COLOR_PURPLE := "\x1b[35;01m"
COLOR_CYAN   := "\x1b[36;01m"

endif

# Current GIT branch
BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null | tr '[:lower:]' '[:upper:]')

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

# 
# Prints a message to the standard output
# 
# @param    The message
# 
PRINT = @echo -e "[ "$(COLOR_PURPLE)$(MAKELEVEL)$(COLOR_NONE) "]> "$(foreach _P,$(BRANCH) $(PROMPT),"[ "$(COLOR_GREEN)$(_P)$(COLOR_NONE)" ]>")" *** "$(1)

# 
# Prints an architecture related message to the standard output
# 
# @param    The architecture
# @param    The message
# 
PRINT_ARCH = $(call PRINT,$(2) [ $(COLOR_RED)$(1)$(COLOR_NONE) ])

# 
# Prints an architecture related message about a file to the standard output
# 
# @param    The architecture
# @param    The message
# @param    The file
# 
PRINT_FILE = $(call PRINT_ARCH,$(1),$(2)): $(3)

# 
# Gets all C files from a specific directory
# 
# @param    The directory
# 
MAKE_FUNC_C_FILES = $(foreach _F,$(wildcard $(1)*$(EXT_C)),$(_F))

# 
# Gets all C++ files from a specific directory
# 
# @param    The directory
# 
MAKE_FUNC_CPP_FILES = $(foreach _F,$(wildcard $(1)*$(EXT_CPP)),$(_F))

# 
# Gets all Objective-C files from a specific directory
# 
# @param    The directory
# 
MAKE_FUNC_M_FILES = $(foreach _F,$(wildcard $(1)*$(EXT_M)),$(_F))

# 
# Gets all object files to build from C sources
# 
# @param    The architecture
# @param    The object file extension
# 
MAKE_FUNC_C_OBJ = $(foreach _F,$(filter %$(EXT_C),$(FILES)),$(patsubst %,$(DIR_BUILD)$(1)/%$(2),$(subst /,.,$(patsubst $(DIR_SRC)%,%,$(_F)))))

# 
# Gets all object files to build from C++ sources
# 
# @param    The architecture
# @param    The object file extension
# 
MAKE_FUNC_CPP_OBJ = $(foreach _F,$(filter %$(EXT_CPP),$(FILES)),$(patsubst %,$(DIR_BUILD)$(1)/%$(2),$(subst /,.,$(patsubst $(DIR_SRC)%,%,$(_F)))))

# 
# Gets all object files to build from Objective-C sources
# 
# @param    The architecture
# @param    The object file extension
# 
MAKE_FUNC_M_OBJ = $(foreach _F,$(filter %$(EXT_M),$(FILES)),$(patsubst %,$(DIR_BUILD)$(1)/%$(2),$(subst /,.,$(patsubst $(DIR_SRC)%,%,$(_F)))))

# 
# Gets all object files to build
# 
# @param    The architecture
# @param    The object file extension
# 
MAKE_FUNC_OBJ = $(call MAKE_FUNC_C_OBJ,$(1),$(2)) $(call MAKE_FUNC_CPP_OBJ,$(1),$(2)) $(call MAKE_FUNC_M_OBJ,$(1),$(2)) $(call MAKE_FUNC_S_OBJ,$(1),$(2))
