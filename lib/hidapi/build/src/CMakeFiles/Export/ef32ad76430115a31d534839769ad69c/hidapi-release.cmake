#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "hidapi::darwin" for configuration "Release"
set_property(TARGET hidapi::darwin APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(hidapi::darwin PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libhidapi.a"
  )

list(APPEND _cmake_import_check_targets hidapi::darwin )
list(APPEND _cmake_import_check_files_for_hidapi::darwin "${_IMPORT_PREFIX}/lib/libhidapi.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
