#!/bin/bash
# Build tests with aarch64-none-elf-gcc.
# This script compiles all C test files to standalone ELF executables.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINTEST_DIR="$(dirname "$SCRIPT_DIR")"
SRC_DIR="${BINTEST_DIR}/tests"
OUT_DIR="${1:-${BINTEST_DIR}/out/a64}"

CC="aarch64-none-elf-gcc"
CXX="aarch64-none-elf-g++"

# Common flags
CFLAGS="-O2 -ffreestanding -nostdlib -nostartfiles"
CFLAGS="${CFLAGS} -I${BINTEST_DIR}/include"
CFLAGS="${CFLAGS} -Wall -Wextra"

mkdir -p "$OUT_DIR"

LINKER_SCRIPT="$(mktemp /tmp/bintest_a64.XXXXXX.ld)"
BARE_LINKER_SCRIPT="$(mktemp /tmp/bare_test_a64.XXXXXX.ld)"
STARTUP_ASM="$(mktemp /tmp/start_a64.XXXXXX.S)"
trap 'rm -f "$LINKER_SCRIPT" "$BARE_LINKER_SCRIPT" "$STARTUP_ASM"' EXIT

# Linker script - single contiguous region for QEMU user mode compatibility.
cat > "$LINKER_SCRIPT" << 'EOF'
ENTRY(_start)

/* Single memory region - all code/data/stack in one mapped area */
/* QEMU user mode needs everything in one contiguous region */
MEMORY
{
    RAM (rwx) : ORIGIN = 0x400000, LENGTH = 8M
}

SECTIONS
{
    . = ORIGIN(RAM);
    
    .text : {
        *(.text)
        *(.text.*)
    } > RAM

    .rodata : {
        *(.rodata)
        *(.rodata.*)
    } > RAM

    .data : {
        *(.data)
        *(.data.*)
    } > RAM

    .bss : {
        __bss_start = .;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        __bss_end = .;
    } > RAM

    .heap : {
        __heap_start = .;
        . = . + 2M;
        __heap_end = .;
    } > RAM

    /* Stack at end of RAM region, grows downward */
    .stack (NOLOAD) : {
        . = ALIGN(16);
        . = . + 64K;  /* 64KB stack */
        __stack_top = .;
    } > RAM
}
EOF

# Linker script for bare-metal tests that define their own _start.
cat > "$BARE_LINKER_SCRIPT" << 'EOF'
ENTRY(_start)
MEMORY
{
    RAM (rwx) : ORIGIN = 0x400000, LENGTH = 1M
}
SECTIONS
{
    . = ORIGIN(RAM);
    .text : { *(.text) *(.text.*) } > RAM
    .rodata : { *(.rodata) *(.rodata.*) } > RAM
    .data : { *(.data) *(.data.*) } > RAM
    .bss : { *(.bss) *(.bss.*) } > RAM
}
EOF

# Startup code - uses Linux ARM64 syscall convention.
cat > "$STARTUP_ASM" << 'EOF'
.section .text
.global _start
.type _start, %function
_start:
    // Set up stack pointer
    ldr x0, =__stack_top
    mov sp, x0
    
    // Clear BSS
    ldr x0, =__bss_start
    ldr x1, =__bss_end
bss_clear:
    cmp x0, x1
    b.ge bss_done
    str xzr, [x0], #8
    b bss_clear
bss_done:
    
    // Call test_main
    bl test_main
    
    // Exit with return value (Linux ARM64: syscall number in x8)
    // exit_group(status): syscall 94, arg in x0
    mov x8, #94      // SYS_EXIT_GROUP
    svc #0
    
    // Should not reach here
    b .
.size _start, . - _start
EOF

build_test() {
    local src="$1"
    local out="$2"
    local no_startup="$3"  # Optional: set to "1" to skip startup code
    
    local dir
    dir=$(dirname "$out")
    mkdir -p "$dir"
    
    local ext
    ext="${src##*.}"
    local compiler="$CC"
    if [ "$ext" = "cpp" ] || [ "$ext" = "cxx" ]; then
        compiler="$CXX"
    fi
    
    if [ "$no_startup" = "1" ]; then
        # Bare-metal test with own _start - compile without startup code
        $compiler $CFLAGS -T "$BARE_LINKER_SCRIPT" -nostartfiles "$src" -o "$out"
    else
        $compiler $CFLAGS -T "$LINKER_SCRIPT" "$STARTUP_ASM" "$src" -o "$out" -lgcc
    fi
}

should_skip_a64() {
    local name="$1"
    case "$name" in
        a32_*) return 0 ;;
    esac
    return 1
}

echo "Building binary tests..."

count=0
failed=0

# Tests that define their own _start (bare-metal tests)
# These need to be compiled without startup code
# Currently empty - all tests use standard framework
BARE_TESTS=()

is_bare_test() {
    local name="$1"
    for t in "${BARE_TESTS[@]}"; do
        if [ "$name" = "$t" ]; then
            return 0
        fi
    done
    return 1
}

for group in group1_basic group2_instructions group3_complex group4_vector group5_mixed crypto datastruct math scientific string workload; do
    group_dir="${SRC_DIR}/${group}"
    if [ -d "$group_dir" ]; then
        for src in "${group_dir}"/*.c; do
            if [ -f "$src" ]; then
                name=$(basename "${src%.*}")
                if should_skip_a64 "$name"; then
                    continue
                fi

                out="${OUT_DIR}/${group}/${name}.elf"
                echo "  Building: ${group}/${name}"
                
                # Check if it's a bare-metal test
                if is_bare_test "$name"; then
                    if build_test "$src" "$out" "1" 2>&1; then
                        count=$((count + 1))
                    else
                        echo "    FAILED to build"
                        failed=$((failed + 1))
                    fi
                else
                    if build_test "$src" "$out" 2>&1; then
                        count=$((count + 1))
                    else
                        echo "    FAILED to build"
                        failed=$((failed + 1))
                    fi
                fi
            fi
        done
    fi
done

echo ""
echo "Built $count tests, $failed failures"
[ "$failed" -eq 0 ]
