[![license](https://img.shields.io/github/license/micro-os-plus/devices-qemu-cortexm-xpack)](https://github.com/micro-os-plus/devices-qemu-cortexm-xpack/blob/xpack/LICENSE)
[![CI on Push](https://github.com/micro-os-plus/devices-qemu-cortexm-xpack/workflows/CI%20on%20Push/badge.svg)](https://github.com/micro-os-plus/devices-qemu-cortexm-xpack/actions?query=workflow%3A%22CI+on+Push%22)

# A source library xPack with the µOS++ QEMU Cortex-M board support files

QEMU implements several Cortex-M boards, which can be used for running
tests.

This project provides the initialization code required to build
applications running on these boards.

It is intended to be included in unit tests, which generally do not
need peripherals.

## Maintainer info

This page is addressed to developers who plan to include this source
library into their own projects.

For maintainer info, please see the
[README-MAINTAINER](README-MAINTAINER.md) file.

## Install

As a source library xPacks, the easiest way to add it to a project is via
**xpm**, but it can also be used as any Git project, for example as a submodule.

### Prerequisites

A recent [xpm](https://xpack.github.io/xpm/),
which is a portable [Node.js](https://nodejs.org/) command line application.

For details please follow the instructions in the
[xPack install](https://xpack.github.io/install/) page.

### xpm

Note: the package will be available from npmjs.com at a later date.

For now, it can be installed from GitHub:

```sh
cd my-project
xpm init # Unless a package.json is already present

xpm install github:micro-os-plus/devices-qemu-cortexm-xpack
```

When ready, this package will be available as
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

## User info

This project can be used as-is for simple tests or blinky projects.

It can also be copied into
the user project, the configuration updated, and content regenerated,
at any time.

### Status

The QEMU Cortex-M support is work in progress.

### Limitations

The emulated boards provide a limited range of peripherals, but for
running unit tests these peripherals are not necessary.

The current initialisation code does not touch them.

### Build & integration info

To integrate this package into user projects, consider the following details:

#### Source folders

- `src`

##### Include folders

- `include`
- `include/cmsis-core`

The header files to be included in user project are:

```c
#include <micro-os-plus/device.h>
```

#### Preprocessor definitions

- `MICRO_OS_PLUS_INCLUDE_MICRO_OS_PLUS_DIAG_TRACE` to enable the `trace_printf()`
  calls in `Error_Handler()` and `assert_failed()`.

#### Compiler options

- `-std=c++20` or higher for C++ sources
- `-std=c11` for C sources

#### Interrupt handlers

Only the standard Cortex-M trap handlers are used.

#### C++ Namespaces

- none

#### C++ Classes

- none

### Examples

TBD

### Known problems

- none

### Tests

TBD

## License

The original content is released under the
[MIT License](https://opensource.org/licenses/MIT/),
with all rights reserved to
[Liviu Ionescu](https://github.com/ilg-ul/).
