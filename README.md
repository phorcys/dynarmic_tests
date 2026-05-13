# dynarmic_tests

External regression tests for Dynarmic frontends and host backends.

This repository intentionally lives outside Eden's normal dynarmic tree. It
contains the asm and binary workloads collected during the LoongArch64 port,
but the tests are meant to run against every Dynarmic backend where available:
x64, arm64, loongarch64, and riscv64.

## Layout

- `asm/a64`: AArch64 assembly regression tests.
- `asm/a32`: ARM/A32 assembly regression tests.
- `bintest/tests`: AArch64 bare-metal C workloads.
- `bintest/include`: minimal bare-metal test headers.
- `bintest/scripts`: toolchain build helpers.
- `runners`: Dynarmic ELF runners.
- `scripts/dynarmic-tests`: common command-line entry point.

Generated ELF files, core files, and local artifacts are not tracked.

## Configure With Eden

From an Eden checkout:

```sh
cmake -S externals/dynarmic_tests -B build/dynarmic_tests \
  -DDYNARMIC_TESTS_EDEN_ROOT="$PWD" \
  -DDYNARMIC_TESTS_ENABLE_RUNNERS=ON
cmake --build build/dynarmic_tests
```

The CMake project will add Eden's `src/dynarmic` when it does not already see a
`dynarmic` target.

If the host machine does not have Boost headers in the default include path,
pass the parent directory that contains `boost/`:

```sh
cmake -S externals/dynarmic_tests -B build/dynarmic_tests \
  -DDYNARMIC_TESTS_EDEN_ROOT="$PWD" \
  -DDYNARMIC_TESTS_BOOST_INCLUDE_DIR="$HOME/work/boost_headers"
```

## Build Binary Workloads

```sh
externals/dynarmic_tests/scripts/dynarmic-tests build-a64 --out build/dynarmic_tests/generated/a64
externals/dynarmic_tests/scripts/dynarmic-tests build-a32 --out build/dynarmic_tests/generated/a32
externals/dynarmic_tests/scripts/dynarmic-tests build-simde --simde "$PWD/externals/simde" --out build/dynarmic_tests/generated/simde
```

Required cross toolchains:

- `aarch64-none-elf-gcc` for A64 bintests and SIMDe bintests.
- `arm-none-eabi-gcc` for A32 bintests.

## Run

```sh
ctest --test-dir build/dynarmic_tests --output-on-failure
```

Or run directly:

```sh
build/dynarmic_tests/dynarmic_bintest_a64 build/dynarmic_tests/generated/a64
build/dynarmic_tests/dynarmic_bintest_a32 build/dynarmic_tests/generated/a32
build/dynarmic_tests/dynarmic_bintest_a64 build/dynarmic_tests/generated/simde
```

The asm corpus currently carries source cases and helper scripts. The next step
is to add a CMake/CTest asm runner that assembles each case into the same build
output tree and executes it through the Dynarmic runners.
