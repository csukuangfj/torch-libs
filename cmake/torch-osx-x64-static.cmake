# Copyright (c)  2024  Xiaomi Corporation
message(STATUS "CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
message(STATUS "CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")

if(NOT CMAKE_SYSTEM_NAME STREQUAL Darwin)
  message(FATAL_ERROR "This file is for macOS only. Given: ${CMAKE_SYSTEM_NAME}")
endif()

if(NOT CMAKE_SYSTEM_PROCESSOR STREQUAL x86_64)
  message(FATAL_ERROR "This file is for x86_64 only. Given: ${CMAKE_SYSTEM_PROCESSOR}")
endif()

if(BUILD_SHARED_LIBS)
  message(FATAL_ERROR "This file is for building static libraries. BUILD_SHARED_LIBS: ${BUILD_SHARED_LIBS}")
endif()

set(torch_libs_URL  "https://huggingface.co/csukuangfj/torch-libs/resolve/main/torch-osx-x64-static-v2.3.1.tar.bz2")
set(torch_libs_URL2 "https://hf-mirror.com/csukuangfj/torch-libs/resolve/main/torch-osx-x64-static-v2.3.1.tar.bz2")
set(torch_libs_HASH "SHA256=0224e88f4525daac40e830db25350a18c8260ed983167fed6a19230e20b8e18d")

# If you don't have access to the Internet,
# please download torch-libs to one of the following locations.
# You can add more if you want.
set(possible_file_locations
  $ENV{HOME}/Downloads/torch-osx-x64-static-v2.3.1.tar.bz2
  ${CMAKE_SOURCE_DIR}/torch-osx-x64-static-v2.3.1.tar.bz2
  ${CMAKE_BINARY_DIR}/torch-osx-x64-static-v2.3.1.tar.bz2
  /tmp/torch-osx-x64-static-v2.3.1.tar.bz2
  /star-fj/fangjun/download/github/torch-osx-x64-static-v2.3.1.tar.bz2
)

foreach(f IN LISTS possible_file_locations)
  if(EXISTS ${f})
    set(torch_libs_URL  "${f}")
    file(TO_CMAKE_PATH "${torch_libs_URL}" torch_libs_URL)
    message(STATUS "Found local downloaded torch-libs: ${torch_libs_URL}")
    set(torch_libs_URL2)
    break()
  endif()
endforeach()

FetchContent_Declare(torch_libs
  URL
    ${torch_libs_URL}
    ${torch_libs_URL}
  URL_HASH          ${torch_libs_HASH}
)

FetchContent_GetProperties(torch_libs)
if(NOT torch_libs_POPULATED)
  message(STATUS "Downloading torch-libs from ${torch_libs_URL}")
  FetchContent_Populate(torch_libs)
endif()
message(STATUS "torch-libs is downloaded to ${torch_libs_SOURCE_DIR}")

list(APPEND CMAKE_PREFIX_PATH "${torch_libs_SOURCE_DIR}")

if(NOT DEFINED TORCH_LIBRARY)
  find_package(Torch REQUIRED)
endif()

message(STATUS "TORCH_FOUND: ${TORCH_FOUND}")
message(STATUS "TORCH_INCLUDE_DIRS: ${TORCH_INCLUDE_DIRS}")
message(STATUS "TORCH_LIBRARIES: ${TORCH_LIBRARIES}")
message(STATUS "TORCH_CXX_FLAGS: ${TORCH_CXX_FLAGS}")

include_directories(${torch_libs_SOURCE_DIR}/include/torch/csrc/api/include)
include_directories(${torch_libs_SOURCE_DIR}/include)
