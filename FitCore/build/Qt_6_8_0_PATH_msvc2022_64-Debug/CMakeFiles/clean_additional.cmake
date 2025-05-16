# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appFitCore_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appFitCore_autogen.dir\\ParseCache.txt"
  "appFitCore_autogen"
  )
endif()
