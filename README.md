[![license](https://img.shields.io/github/license/micro-os-plus/devices-qemu-cortexm-xpack)](https://github.com/micro-os-plus/devices-qemu-cortexm-xpack/blob/xpack/LICENSE)
[![CI on Push](https://github.com/micro-os-plus/devices-qemu-cortexm-xpack/actions/workflows/CI.yml/badge.svg)](https://github.com/micro-os-plus/devices-qemu-cortexm-xpack/actions/workflows/CI.yml)

# A source library xPack with the µOS++ QEMU Cortex-M board support files

This project provides the **devices-qemu-cortexm** source library as an xPack
dependency and includes the initialization code required to build
applications running on these boards.

It is intended to be included in unit tests, which generally do not
need peripherals.

The project is hosted on GitHub as
[micro-os-plus/devices-qemu-cortexm-xpack](https://github.com/micro-os-plus/devices-qemu-cortexm-xpack).

## Maintainer info

This page is addressed to developers who plan to include this source
library into their own projects.

For maintainer info, please see the
[README-MAINTAINER](README-MAINTAINER.md) file.

## Install

As a source library xPack, the easiest way to add it to a project is via
**xpm**, but it can also be used as any Git project, for example as a submodule.

### Prerequisites

A recent [xpm](https://xpack.github.io/xpm/),
which is a portable [Node.js](https://nodejs.org/) command line application.

For details please follow the instructions in the
[xPack install](https://xpack.github.io/install/) page.

### xpm

This package is available from npmjs.com as
[`@micro-os-plus/devices-qemu-cortexm`](https://www.npmjs.com/package/@micro-os-plus/devices-qemu-cortexm)
from the `npmjs.com` registry:

```sh
cd my-project
xpm init # Unless a package.json is already present

xpm install @micro-os-plus/devices-qemu-cortexm@latest

ls -l xpacks/micro-os-plus-devices-qemu-cortexm
```

### Git submodule

If, for any reason, **xpm** is not available, the next recommended
solution is to link it as a Git submodule below an `xpacks` folder.

```sh
cd my-project
git init # Unless already a Git project
mkdir -p xpacks

git submodule add https://github.com/micro-os-plus/devices-qemu-cortexm-xpack.git \
  xpacks/micro-os-plus-devices-qemu-cortexm-xpack
```

## Branches

Apart from the unused `master` branch, there are two active branches:

- `xpack`, with the latest stable version (default)
- `xpack-develop`, with the current development version

All development is done in the `xpack-develop` branch, and contributions via
Pull Requests should be directed to this branch.

When new releases are published, the `xpack-develop` branch is merged
into `xpack`.

## Developer info

### Overview

QEMU implements several RISC-V boards, which can be used for running
tests.

- <https://www.qemu.org/docs/master/system/target-arm.html>
- <https://www.qemu.org/docs/master/system/arm/mps2.html>

This project provides the initialization code required to build
applications running on these boards.

### Status

The **device-qemu-cortexm** source library is fully functional,
but minimalistic, for running semihosted tests.

### Limitations

The emulated boards provide a limited range of peripherals, but for
running unit tests these peripherals are not necessary.

The current initialisation code does not touch them.

### Build & integration info

The project is written in C++ and assembly and it is expected
to be used in C and C++ projects.

The source code was compiled with
arm-none-eabi-gcc 11, and should be warning free.

To ease the integration of this package into user projects, there
are already made CMake and meson configuration files (see below).

For other build systems, consider the following details:

#### Include folders

The following folders should be passed to the compiler during the build:

- `include`

The header files to be included in user project are:

```c
#include <micro-os-plus/device.h>
```

#### Source files

The source files to be added to user projects are:

- `src/system_cortexm.c`
- `src/vectors_cortexm.c`
- `src/reset-handler.c`
- `src/exception-handlers.c`

#### Preprocessor definitions

- none

#### Compiler options

- `-std=c++20` or higher for C++ sources
- `-std=c11` for C sources

#### Interrupt handlers

Only the standard Cortex-M trap handlers are used.

#### C++ Namespaces

- none

#### C++ Classes

- none

#### Dependencies

- none

#### CMake

To integrate the devices-qemu-cortexm source library into a CMake application,
add this folder to the build:

```cmake
add_subdirectory("xpacks/micro-os-plus-devices-qemu-cortexm")`
```

The result is an interface library that can be added as an application
dependency with:

```cmake
target_link_libraries(your-target PRIVATE

  micro-os-plus::devices-qemu-cortexm
)
```

#### meson

To integrate the devices-qemu-cortexm source library into a meson application,
add this folder to the build:

```meson
subdir('xpacks/micro-os-plus-devices-qemu-cortexm')
```

The result is a dependency object that can be added
to an application with:

```meson
exe = executable(
  your-target,
  link_with: [
    # Nothing, not static.
  ],
  dependencies: [
    micro_os_plus_devices_qemu_cortexm_dependency,
  ]
)
```

### Examples

TBD

### Known problems

- none

### Tests

TBD

## Change log - incompatible changes

According to [semver](https://semver.org) rules:

> Major version X (X.y.z | X > 0) MUST be incremented if any
backwards incompatible changes are introduced to the public API.

The incompatible changes, in reverse chronological order,
are:

- v4.x: rename mem-mps2-*.ld; non-weak Reset_Handler
- v3.x: rename MICRO_OS_PLUS_DEBUG
- v2.x: rename devices-qemu-cortexm

## License

The original content is released under the
[MIT License](https://opensource.org/licenses/MIT/),
with all rights reserved to
[Liviu Ionescu](https://github.com/ilg-ul/).
