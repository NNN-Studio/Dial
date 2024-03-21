# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.27

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/homebrew/Cellar/cmake/3.27.7/bin/cmake

# The command to remove a file.
RM = /opt/homebrew/Cellar/cmake/3.27.7/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/Kr/Documents/Swift/Dial/lib/hidapi

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86

# Include any dependencies generated for this target.
include src/mac/CMakeFiles/hidapi_darwin.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/mac/CMakeFiles/hidapi_darwin.dir/compiler_depend.make

# Include the progress variables for this target.
include src/mac/CMakeFiles/hidapi_darwin.dir/progress.make

# Include the compile flags for this target's objects.
include src/mac/CMakeFiles/hidapi_darwin.dir/flags.make

src/mac/CMakeFiles/hidapi_darwin.dir/hid.c.o: src/mac/CMakeFiles/hidapi_darwin.dir/flags.make
src/mac/CMakeFiles/hidapi_darwin.dir/hid.c.o: /Users/Kr/Documents/Swift/Dial/lib/hidapi/mac/hid.c
src/mac/CMakeFiles/hidapi_darwin.dir/hid.c.o: src/mac/CMakeFiles/hidapi_darwin.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object src/mac/CMakeFiles/hidapi_darwin.dir/hid.c.o"
	cd /Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86/src/mac && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT src/mac/CMakeFiles/hidapi_darwin.dir/hid.c.o -MF CMakeFiles/hidapi_darwin.dir/hid.c.o.d -o CMakeFiles/hidapi_darwin.dir/hid.c.o -c /Users/Kr/Documents/Swift/Dial/lib/hidapi/mac/hid.c

src/mac/CMakeFiles/hidapi_darwin.dir/hid.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/hidapi_darwin.dir/hid.c.i"
	cd /Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86/src/mac && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/Kr/Documents/Swift/Dial/lib/hidapi/mac/hid.c > CMakeFiles/hidapi_darwin.dir/hid.c.i

src/mac/CMakeFiles/hidapi_darwin.dir/hid.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/hidapi_darwin.dir/hid.c.s"
	cd /Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86/src/mac && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/Kr/Documents/Swift/Dial/lib/hidapi/mac/hid.c -o CMakeFiles/hidapi_darwin.dir/hid.c.s

# Object files for target hidapi_darwin
hidapi_darwin_OBJECTS = \
"CMakeFiles/hidapi_darwin.dir/hid.c.o"

# External object files for target hidapi_darwin
hidapi_darwin_EXTERNAL_OBJECTS =

src/mac/libhidapi.a: src/mac/CMakeFiles/hidapi_darwin.dir/hid.c.o
src/mac/libhidapi.a: src/mac/CMakeFiles/hidapi_darwin.dir/build.make
src/mac/libhidapi.a: src/mac/CMakeFiles/hidapi_darwin.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C static library libhidapi.a"
	cd /Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86/src/mac && $(CMAKE_COMMAND) -P CMakeFiles/hidapi_darwin.dir/cmake_clean_target.cmake
	cd /Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86/src/mac && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/hidapi_darwin.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/mac/CMakeFiles/hidapi_darwin.dir/build: src/mac/libhidapi.a
.PHONY : src/mac/CMakeFiles/hidapi_darwin.dir/build

src/mac/CMakeFiles/hidapi_darwin.dir/clean:
	cd /Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86/src/mac && $(CMAKE_COMMAND) -P CMakeFiles/hidapi_darwin.dir/cmake_clean.cmake
.PHONY : src/mac/CMakeFiles/hidapi_darwin.dir/clean

src/mac/CMakeFiles/hidapi_darwin.dir/depend:
	cd /Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/Kr/Documents/Swift/Dial/lib/hidapi /Users/Kr/Documents/Swift/Dial/lib/hidapi/mac /Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86 /Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86/src/mac /Users/Kr/Documents/Swift/Dial/lib/hidapi/build_x86/src/mac/CMakeFiles/hidapi_darwin.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : src/mac/CMakeFiles/hidapi_darwin.dir/depend

