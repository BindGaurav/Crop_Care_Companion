# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.30

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
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/beastnova/flutter_project/my_app/linux

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/beastnova/flutter_project/my_app/linux/build

# Include any dependencies generated for this target.
include CMakeFiles/my_app.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/my_app.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/my_app.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/my_app.dir/flags.make

CMakeFiles/my_app.dir/main.cc.o: CMakeFiles/my_app.dir/flags.make
CMakeFiles/my_app.dir/main.cc.o: /home/beastnova/flutter_project/my_app/linux/main.cc
CMakeFiles/my_app.dir/main.cc.o: CMakeFiles/my_app.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/beastnova/flutter_project/my_app/linux/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/my_app.dir/main.cc.o"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/my_app.dir/main.cc.o -MF CMakeFiles/my_app.dir/main.cc.o.d -o CMakeFiles/my_app.dir/main.cc.o -c /home/beastnova/flutter_project/my_app/linux/main.cc

CMakeFiles/my_app.dir/main.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/my_app.dir/main.cc.i"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/beastnova/flutter_project/my_app/linux/main.cc > CMakeFiles/my_app.dir/main.cc.i

CMakeFiles/my_app.dir/main.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/my_app.dir/main.cc.s"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/beastnova/flutter_project/my_app/linux/main.cc -o CMakeFiles/my_app.dir/main.cc.s

CMakeFiles/my_app.dir/my_application.cc.o: CMakeFiles/my_app.dir/flags.make
CMakeFiles/my_app.dir/my_application.cc.o: /home/beastnova/flutter_project/my_app/linux/my_application.cc
CMakeFiles/my_app.dir/my_application.cc.o: CMakeFiles/my_app.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/beastnova/flutter_project/my_app/linux/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/my_app.dir/my_application.cc.o"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/my_app.dir/my_application.cc.o -MF CMakeFiles/my_app.dir/my_application.cc.o.d -o CMakeFiles/my_app.dir/my_application.cc.o -c /home/beastnova/flutter_project/my_app/linux/my_application.cc

CMakeFiles/my_app.dir/my_application.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/my_app.dir/my_application.cc.i"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/beastnova/flutter_project/my_app/linux/my_application.cc > CMakeFiles/my_app.dir/my_application.cc.i

CMakeFiles/my_app.dir/my_application.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/my_app.dir/my_application.cc.s"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/beastnova/flutter_project/my_app/linux/my_application.cc -o CMakeFiles/my_app.dir/my_application.cc.s

CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.o: CMakeFiles/my_app.dir/flags.make
CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.o: /home/beastnova/flutter_project/my_app/linux/flutter/generated_plugin_registrant.cc
CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.o: CMakeFiles/my_app.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/beastnova/flutter_project/my_app/linux/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.o"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.o -MF CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.o.d -o CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.o -c /home/beastnova/flutter_project/my_app/linux/flutter/generated_plugin_registrant.cc

CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.i"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/beastnova/flutter_project/my_app/linux/flutter/generated_plugin_registrant.cc > CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.i

CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.s"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/beastnova/flutter_project/my_app/linux/flutter/generated_plugin_registrant.cc -o CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.s

# Object files for target my_app
my_app_OBJECTS = \
"CMakeFiles/my_app.dir/main.cc.o" \
"CMakeFiles/my_app.dir/my_application.cc.o" \
"CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.o"

# External object files for target my_app
my_app_EXTERNAL_OBJECTS =

intermediates_do_not_run/my_app: CMakeFiles/my_app.dir/main.cc.o
intermediates_do_not_run/my_app: CMakeFiles/my_app.dir/my_application.cc.o
intermediates_do_not_run/my_app: CMakeFiles/my_app.dir/flutter/generated_plugin_registrant.cc.o
intermediates_do_not_run/my_app: CMakeFiles/my_app.dir/build.make
intermediates_do_not_run/my_app: /home/beastnova/flutter_project/my_app/linux/flutter/ephemeral/libflutter_linux_gtk.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libgtk-3.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libgdk-3.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libpangocairo-1.0.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libpango-1.0.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libharfbuzz.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libatk-1.0.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libcairo-gobject.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libcairo.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libgdk_pixbuf-2.0.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libgio-2.0.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libgobject-2.0.so
intermediates_do_not_run/my_app: /usr/lib/x86_64-linux-gnu/libglib-2.0.so
intermediates_do_not_run/my_app: CMakeFiles/my_app.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/home/beastnova/flutter_project/my_app/linux/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking CXX executable intermediates_do_not_run/my_app"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/my_app.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/my_app.dir/build: intermediates_do_not_run/my_app
.PHONY : CMakeFiles/my_app.dir/build

CMakeFiles/my_app.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/my_app.dir/cmake_clean.cmake
.PHONY : CMakeFiles/my_app.dir/clean

CMakeFiles/my_app.dir/depend:
	cd /home/beastnova/flutter_project/my_app/linux/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/beastnova/flutter_project/my_app/linux /home/beastnova/flutter_project/my_app/linux /home/beastnova/flutter_project/my_app/linux/build /home/beastnova/flutter_project/my_app/linux/build /home/beastnova/flutter_project/my_app/linux/build/CMakeFiles/my_app.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/my_app.dir/depend

