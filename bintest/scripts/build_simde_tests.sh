#!/bin/bash
# Build SIMDe NEON Tests
#
# Compiles SIMDe's ARM NEON tests as bare-metal ELF executables
# for use with dynarmic's bintest_runner.
#
# Key points:
# 1. Use -include simde_bare_adapt.h to intercept stdlib headers
# 2. Compile simde_start.S separately (no -include)
# 3. Compile simde_lib.c separately (no -include)
# 4. Compile test files with -include simde_bare_adapt.h

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINTEST_DIR="$(dirname "$SCRIPT_DIR")"
SIMDE_SRC="${SIMDE_SRC:-}"
OUTPUT_DIR="${1:-${BINTEST_DIR}/out/simde}"

if [ -z "$SIMDE_SRC" ]; then
    echo "SIMDE_SRC must point to a SIMDe checkout" >&2
    exit 2
fi

CC="aarch64-none-elf-gcc"

# Compiler flags
COMMON_FLAGS="-O2 -ffreestanding"
CFLAGS="${COMMON_FLAGS} -march=armv8-a+crypto+lse"
CFLAGS="${CFLAGS} -I${BINTEST_DIR}/include"
CFLAGS="${CFLAGS} -I${SIMDE_SRC}"
CFLAGS="${CFLAGS} -DSIMDE_TEST_BARE"
CFLAGS="${CFLAGS} -Wall -Wno-unused-function -Wno-format"

# Linker script and support files
LINKER_SCRIPT="${BINTEST_DIR}/scripts/simde.ld"
START_S="${BINTEST_DIR}/scripts/simde_start.S"
SUPPORT_C="${BINTEST_DIR}/scripts/simde_lib.c"

# Pre-compiled support objects
START_O="/tmp/simde_start.o"
SUPPORT_O="/tmp/simde_lib.o"

# Build support objects once
build_support() {
    echo "Building support files..."
    # Assembly file - no -include
    $CC -c $COMMON_FLAGS "$START_S" -o "$START_O"
    # Support library - no -include (has its own implementations)
    $CC -c $COMMON_FLAGS -I"${BINTEST_DIR}/include" "$SUPPORT_C" -o "$SUPPORT_O"
}

# Build a single test
build_test() {
    local src="$1"
    local name
    name=$(basename "${src%.c}")
    local out="${OUTPUT_DIR}/${name}.elf"
    local obj="/tmp/${name}.o"

    # Compile test file WITH -include simde_bare_adapt.h
    $CC -c $CFLAGS -include "${BINTEST_DIR}/include/simde_bare_adapt.h" "$src" -o "$obj" 2>/dev/null || return 1

    # Link with support objects
    $CC -nostdlib -nostartfiles -T "$LINKER_SCRIPT" "$START_O" "$SUPPORT_O" "$obj" -o "$out" -lgcc 2>/dev/null || return 1

    return 0
}

# Main
echo "=== Building SIMDe NEON Tests ==="
echo ""
echo "SIMDe source: $SIMDE_SRC"
echo "Output directory: $OUTPUT_DIR"
echo ""

mkdir -p "$OUTPUT_DIR"

# Build support files once
build_support

count=0
failed=0
failed_list=""

# Build all tests from simde/test/arm/neon/
for src in "$SIMDE_SRC"/test/arm/neon/*.c; do
    name=$(basename "${src%.c}")
    # Skip skeleton/template files
    case "$name" in
        skel*|run-tests)
            continue
            ;;
    esac

    printf "Building: %-30s " "$name"
    if build_test "$src"; then
        echo "OK"
        count=$((count + 1))
    else
        echo "FAILED"
        failed=$((failed + 1))
        failed_list="${failed_list} ${name}"
    fi
done

echo ""
echo "=== Build Summary ==="
echo "Built: $count tests"
echo "Failed: $failed tests"
if [ -n "$failed_list" ]; then
    echo "Failed tests:$failed_list"
fi

echo ""
echo "To run with QEMU:"
echo "  qemu-aarch64 ${OUTPUT_DIR}/abs.elf"
echo ""
echo "To run all tests with dynarmic:"
echo "  dynarmic_bintest_a64 ${OUTPUT_DIR}"

[ "$failed" -eq 0 ]
