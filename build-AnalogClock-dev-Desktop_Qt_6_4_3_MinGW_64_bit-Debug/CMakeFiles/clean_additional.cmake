# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "AnalogClockQML_autogen"
  "CMakeFiles\\AnalogClockQML_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\AnalogClockQML_autogen.dir\\ParseCache.txt"
  )
endif()
