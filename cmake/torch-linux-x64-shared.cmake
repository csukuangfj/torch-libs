# Copyright (c)  2024  Xiaomi Corporation
message(STATUS "CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
message(STATUS "CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")

if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
  message(FATAL_ERROR "This file is for Linux only. Given: ${CMAKE_SYSTEM_NAME}")
endif()

if(NOT CMAKE_SYSTEM_PROCESSOR STREQUAL x86_64)
  message(FATAL_ERROR "This file is for x86_64 only. Given: ${CMAKE_SYSTEM_PROCESSOR}")
endif()

if(NOT BUILD_SHARED_LIBS)
  message(FATAL_ERROR "This file is for building shared libraries. BUILD_SHARED_LIBS: ${BUILD_SHARED_LIBS}")
endif()

set(torch_libs_URL  "https://huggingface.co/csukuangfj/torch-libs/resolve/main/torch-linux-x64-shared-v2.3.1.tar.bz2")
set(torch_libs_URL2 "https://hf-mirror.com/csukuangfj/torch-libs/resolve/main/torch-linux-x64-shared-v2.3.1.tar.bz2")
set(torch_libs_HASH "SHA256=6efdb5c3f344f980e431b0b1d4c5fc78c4bd6d1d9697212467928164885a7ae5")

# If you don't have access to the Internet,
# please download torch-libs to one of the following locations.
# You can add more if you want.
set(possible_file_locations
  $ENV{HOME}/Downloads/torch-linux-x64-shared-v2.3.1.tar.bz2
  ${CMAKE_SOURCE_DIR}/torch-linux-x64-shared-v2.3.1.tar.bz2
  ${CMAKE_BINARY_DIR}/torch-linux-x64-shared-v2.3.1.tar.bz2
  /tmp/torch-linux-x64-shared-v2.3.1.tar.bz2
  /star-fj/fangjun/download/github/torch-linux-x64-shared-v2.3.1.tar.bz2
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
