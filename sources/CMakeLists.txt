#
# This file is part of the µOS++ distribution.
#   (https://github.com/micro-os-plus)
# Copyright (c) 2022 Liviu Ionescu
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
#
# -----------------------------------------------------------------------------

# https://cmake.org/cmake/help/v3.19/

# PRIVATE: build definitions, used internally
# INTERFACE: usage definitions, passed up to targets linking to it
# PUBLIC: both

if(COMMAND xpack_get_package_name_and_version)
  xpack_get_package_name_and_version("${CMAKE_CURRENT_SOURCE_DIR}/../package.json")
  message(VERBOSE "Processing xPack ${PACKAGE_JSON_NAME}@${PACKAGE_JSON_VERSION}...")
endif()

# -----------------------------------------------------------------------------
# Preprocessor symbols.

# TODO: migrate them to CMake options.
set(xpack_platform_compile_definition "PLATFORM_QEMU_MPS2_AN386")
set(xpack_device_compile_definition "DEVICE_QEMU_CORTEX_M4")

# -----------------------------------------------------------------------------

add_library(micro-os-plus-device-static STATIC EXCLUDE_FROM_ALL)

# -------------------------------------------------------------------------

target_sources(
  micro-os-plus-device-static

  PRIVATE
    "src/system_cortexm.c"
    "src/vectors_cortexm.c"
)

message(VERBOSE "+ sources/src/system_cortexm.c")
message(VERBOSE "+ sources/src/vectors_cortexm.c")

target_include_directories(
  micro-os-plus-device-static

  PUBLIC
    "include"
)

message(VERBOSE "+ sources/include")

target_compile_definitions(
  micro-os-plus-device-static

  PUBLIC
    "${xpack_device_compile_definition}"
)

message(VERBOSE "+ ${xpack_device_compile_definition}")

target_compile_options(
  micro-os-plus-device-static

  PRIVATE
    # ...
)

target_link_libraries(
  micro-os-plus-device-static

  PUBLIC
    xpack-3rd-party::arm-cmsis-core-m

    # Use the device specific definitions from the architecture (hack!).
    micro-os-plus::architecture-cortexm-device

    micro-os-plus::startup
)

# -------------------------------------------------------------------------
# Aliases.

add_library(micro-os-plus::device ALIAS micro-os-plus-device-static)
message(VERBOSE "micro-os-plus::device -> micro-os-plus-device-static")

# ===========================================================================

add_library(micro-os-plus-platform-qemu-cortexm-interface STATIC EXCLUDE_FROM_ALL)

# -------------------------------------------------------------------------

target_compile_definitions(
  micro-os-plus-platform-qemu-cortexm-interface

  PUBLIC
    "${xpack_platform_compile_definition}"
)

message(VERBOSE "+ ${xpack_platform_compile_definition}")


target_compile_options(
  micro-os-plus-platform-qemu-cortexm-interface

  PRIVATE
    # To silence HAL warnings.
    -Wno-padded
    -Wno-switch-enum
    -Wno-conversion
    -Wno-redundant-decls
    -Wno-switch-default
    -Wno-unused-parameter

    $<$<COMPILE_LANG_AND_ID:C,GNU>:-Wno-bad-function-cast>
)

target_link_libraries(
  micro-os-plus-platform-qemu-cortexm-interface

  PUBLIC
    micro-os-plus::device
    micro-os-plus::diag-trace
)

# -------------------------------------------------------------------------
# Aliases.

add_library(micro-os-plus::platform-qemu-cortexm ALIAS micro-os-plus-platform-qemu-cortexm-interface)
message(VERBOSE "micro-os-plus::platform-qemu-cortexm -> micro-os-plus-platform-qemu-cortexm-interface")

# -----------------------------------------------------------------------------
