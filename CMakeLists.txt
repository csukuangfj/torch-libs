cmake_minimum_required(VERSION 3.13 FATAL_ERROR)
project(torch-libs)

# Disable warning about
#
# "The DOWNLOAD_EXTRACT_TIMESTAMP option was not given and policy CMP0135 is
#  not set.
if (CMAKE_VERSION VERSION_GREATER_EQUAL "3.24.0")
  cmake_policy(SET CMP0135 NEW)
endif()

option(GLIBCXX_USE_CXX11_ABI "Whether to CXX11 ABI" OFF)
option(BUILD_SHARED_LIBS "Whether to build shared libraries" OFF)

message(STATUS "GLIBCXX_USE_CXX11_ABI ${GLIBCXX_USE_CXX11_ABI}")
message(STATUS "BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS}")

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(torch-libs)
