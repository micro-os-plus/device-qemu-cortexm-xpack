#
# This file is part of the µOS++ distribution.
#   (https://github.com/micro-os-plus)
# Copyright (c) 2022 Liviu Ionescu
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
#
# -----------------------------------------------------------------------------

# This file is intended to be consumed by applications with:
#
# `add_subdirectory("xpacks/micro-os-plus-device-qemu-cortexm")`
#
# The result is a library that can be added to the linker with:
#
# `target_link_libraries(your-target PUBLIC micro-os-plus::device-qemu-cortexm)`

# -----------------------------------------------------------------------------
## Preamble ##

# https://cmake.org/cmake/help/v3.20/
cmake_minimum_required(VERSION 3.20)

project(
  micro-os-plus-device-qemu-cortexm
  DESCRIPTION "µOS++ QEMU Cortex-M devices"
)

if(COMMAND xpack_get_package_name_and_version)
  xpack_get_package_name_and_version("${CMAKE_CURRENT_SOURCE_DIR}/package.json")
  message(VERBOSE "Processing xPack ${PACKAGE_JSON_NAME}@${PACKAGE_JSON_VERSION}...")
endif()

if(NOT xpack_device_compile_definition)
  message(FATAL_ERROR "Define 'xpack_device_compile_definition' globally before including device-qemu-cortexm")
endif()

# -----------------------------------------------------------------------------
## The project library definitions ##

# https://cmake.org/cmake/help/v3.20/command/add_library.html?highlight=interface#normal-libraries
# PRIVATE: build definitions, used internally
# INTERFACE: usage definitions, passed up to targets linking to it
# PUBLIC: both

add_library(micro-os-plus-device-qemu-cortexm-static STATIC EXCLUDE_FROM_ALL)

# -----------------------------------------------------------------------------
# Target settings.

target_sources(
  micro-os-plus-device-qemu-cortexm-static

  PRIVATE
    "src/system_cortexm.c"
    "src/vectors_cortexm.c"
)

message(VERBOSE "+ src/system_cortexm.c")
message(VERBOSE "+ src/vectors_cortexm.c")

target_include_directories(
  micro-os-plus-device-qemu-cortexm-static

  PUBLIC
    "include"
)

message(VERBOSE "+ include")

target_compile_definitions(
  micro-os-plus-device-qemu-cortexm-static

  PUBLIC
    "${xpack_device_compile_definition}"
)

message(VERBOSE "+ ${xpack_device_compile_definition}")

target_compile_options(
  micro-os-plus-device-qemu-cortexm-static

  PRIVATE
    # ...
)

target_link_libraries(
  micro-os-plus-device-qemu-cortexm-static

  PUBLIC
    xpack-3rd-party::arm-cmsis-core-m

    # Use the device specific definitions from the architecture (hack!).
    micro-os-plus::device-cortexm

    micro-os-plus::startup
)

# -----------------------------------------------------------------------------
# Aliases.

add_library(micro-os-plus::device ALIAS micro-os-plus-device-qemu-cortexm-static)
message(VERBOSE "> micro-os-plus::device -> micro-os-plus-device-qemu-cortexm-static")

# -----------------------------------------------------------------------------
