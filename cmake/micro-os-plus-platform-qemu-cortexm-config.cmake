#
# This file is part of the µOS++ distribution.
#   (https://github.com/micro-os-plus)
# Copyright (c) 2021 Liviu Ionescu
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
#
# If a copy of the license was not distributed with this file, it can
# be obtained from https://opensource.org/licenses/MIT/.
#
# -----------------------------------------------------------------------------

# https://cmake.org/cmake/help/v3.19/
# https://cmake.org/cmake/help/v3.19/manual/cmake-packages.7.html#package-configuration-file
cmake_minimum_required(VERSION 3.19)

# Use targets as include markers (variables are not scope independent).
if(TARGET micro-os-plus-platform-qemu-cortexm-included)
  return()
else()
  add_custom_target(micro-os-plus-platform-qemu-cortexm-included)
endif()

if(NOT TARGET micro-os-plus-build-helper-included)
  message(FATAL_ERROR "Include the mandatory build-helper (xpacks/micro-os-plus-build-helper/cmake/xpack-helper.cmake)")
endif()

message(STATUS "Processing xPack ${PACKAGE_JSON_NAME}@${PACKAGE_JSON_VERSION}...")

# -----------------------------------------------------------------------------
# Preprocessor symbols.

# TODO: migrate them to CMake options.
set(xpack_platform_compile_definition "PLATFORM_QEMU_MPS2_AN386")
set(xpack_device_compile_definition "DEVICE_QEMU_CORTEX_M4")

# -----------------------------------------------------------------------------

find_package(xpack-3rd-party-arm-cmsis-core-m)

find_package(micro-os-plus-architecture-cortexm)
find_package(micro-os-plus-startup)
find_package(micro-os-plus-diag-trace)

# -----------------------------------------------------------------------------

  get_filename_component(xpack_current_folder ${CMAKE_CURRENT_LIST_DIR} DIRECTORY)

  # ---------------------------------------------------------------------------

  if (NOT TARGET micro-os-plus-device-static)

    add_library(micro-os-plus-device-static STATIC EXCLUDE_FROM_ALL)

    # -------------------------------------------------------------------------

    xpack_glob_recurse_cxx(source_files "${xpack_current_folder}/src")
    xpack_display_relative_paths("${source_files}" "${xpack_current_folder}")

    target_sources(
      micro-os-plus-device-static

      PRIVATE
        ${source_files}
    )

    target_include_directories(
      micro-os-plus-device-static

      PUBLIC
        ${xpack_current_folder}/include
      )

    message(STATUS "+ ${xpack_device_compile_definition}")

    target_compile_definitions(
      micro-os-plus-device-static

      PUBLIC
        "${xpack_device_compile_definition}"
    )

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
    message(STATUS "=> micro-os-plus::device (micro-os-plus-device-static)")

  endif()

  # ===========================================================================

  if (NOT micro-os-plus-platform-qemu-cortexm-interface)

    add_library(micro-os-plus-platform-qemu-cortexm-interface STATIC EXCLUDE_FROM_ALL)

    # -------------------------------------------------------------------------

    message(STATUS "+ ${xpack_platform_compile_definition}")

    target_compile_definitions(
      micro-os-plus-platform-qemu-cortexm-interface

      PUBLIC
        "${xpack_platform_compile_definition}"
    )


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
    message(STATUS "=> micro-os-plus::platform-qemu-cortexm (micro-os-plus-platform-qemu-cortexm-interface)")

  endif()

# -----------------------------------------------------------------------------
