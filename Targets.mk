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

# Clear any existing search path
VPATH =
vpath

# Add search paths for source files
vpath %$(EXT_C)   $(DIR_SRC)
vpath %$(EXT_CPP) $(DIR_SRC)
vpath %$(EXT_M)   $(DIR_SRC)

# Clears any existing suffix
.SUFFIXES:

# Phony targets
.PHONY: all clean build _build

# Precious targets
.PRECIOUS: $(DIR_BUILD)%$(EXT_O)               \
           $(DIR_BUILD)%$(EXT_C)$(EXT_O)       \
           $(DIR_BUILD)%$(EXT_CPP)$(EXT_O)     \
           $(DIR_BUILD)%$(EXT_M)$(EXT_O)

#-------------------------------------------------------------------------------
# Targets with second expansion
#-------------------------------------------------------------------------------

.SECONDEXPANSION:

# Build executable
build:
	
	@$(MAKE) _build
	
# Clean all build files
clean:
	
	$(call PRINT,Cleaning all build files)
	@rm -rf $(DIR_BUILD)*
	
# Build executable
_build: _FILES = $(call MAKE_FUNC_OBJ,$(HOST_ARCH),$(EXT_O))
_build: _CC    = $(CC)
_build: _FLAGS = $(ARGS_CC)
_build: _LIBS  = $(foreach _L,$(LIBS),$(addprefix -l,$(_L)))
_build: $$(_FILES)
	
	$(call PRINT_FILE,$(HOST_ARCH),$(COLOR_CYAN)Creating executbale$(COLOR_NONE),$(COLOR_GRAY)$(TOOL)$(COLOR_NONE))
	@$(_CC) $(_FLAGS) $(_LIBS) -o $(DIR_BUILD)$(TOOL) $(_FILES)
	
# Avoids stupid search rules...
%$(EXT_C):
%$(EXT_CPP):
%$(EXT_M):

# Compiles a C file
$(DIR_BUILD)%$(EXT_C)$(EXT_O): _FILE  = $(subst .,/,$(patsubst $(HOST_ARCH)/%,%,$*))$(EXT_C)
$(DIR_BUILD)%$(EXT_C)$(EXT_O): $$(shell mkdir -p $$(DIR_BUILD)$$(HOST_ARCH)) $$(_FILE)
	
	$(call PRINT_FILE,$(HOST_ARCH),Compiling C file,$(COLOR_YELLOW)$(_FILE)$(COLOR_NONE) "->" $(COLOR_GRAY)$(notdir $@)$(COLOR_NONE))
	@$(CC) $(ARGS_CC) $(ARGS_C) -o $@ -c $<

# Compiles a C++ file
$(DIR_BUILD)%$(EXT_CPP)$(EXT_O): _FILE  = $(subst .,/,$(patsubst $(HOST_ARCH)/%,%,$*))$(EXT_CPP)
$(DIR_BUILD)%$(EXT_CPP)$(EXT_O): $$(shell mkdir -p $$(DIR_BUILD)$$(HOST_ARCH)) $$(_FILE)
	
	$(call PRINT_FILE,$(HOST_ARCH),Compiling C++ file,$(COLOR_YELLOW)$(_FILE)$(COLOR_NONE) "->" $(COLOR_GRAY)$(notdir $@)$(COLOR_NONE))
	@$(CC) $(ARGS_CC) $(ARGS_CC_CPP) -o $@ -c $<

# Compiles an Objective-C file
$(DIR_BUILD)%$(EXT_M)$(EXT_O): _FILE  = $(subst .,/,$(patsubst $(HOST_ARCH)/%,%,$*))$(EXT_M)
$(DIR_BUILD)%$(EXT_M)$(EXT_O): $$(shell mkdir -p $$(DIR_BUILD)$$(HOST_ARCH)) $$(_FILE)
	
	$(call PRINT_FILE,$(HOST_ARCH),Compiling Objective-C file,$(COLOR_YELLOW)$(_FILE)$(COLOR_NONE) "->" $(COLOR_GRAY)$(notdir $@)$(COLOR_NONE))
	@$(CC) $(ARGS_CC) $(ARGS_CC_M) -o $@ -c $<

# Empty target to force special targets to be built
FORCE:

	@:
