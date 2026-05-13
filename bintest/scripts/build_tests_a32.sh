#!/bin/bash
# Build tests with arm-none-eabi-gcc for A32
# Outputs ELF files into the directory passed as argv[1], or bintest/out/a32.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINTEST_DIR="$(dirname "$SCRIPT_DIR")"
SRC_DIR="${BINTEST_DIR}/tests"
OUT_DIR="${1:-${BINTEST_DIR}/out/a32}"

CC="arm-none-eabi-gcc"
CXX="arm-none-eabi-g++"

CFLAGS="-O2 -ffreestanding -nostdlib -nostartfiles -fno-builtin -fno-builtin-memcpy -fno-builtin-memset -fno-builtin-memmove -fno-builtin-memcmp -marm -march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=softfp"
CFLAGS="${CFLAGS} -I${BINTEST_DIR}/include"
CFLAGS="${CFLAGS} -Wall -Wextra"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

LINKER_SCRIPT="$(mktemp /tmp/bintest_a32.XXXXXX.ld)"
STARTUP_ASM="$(mktemp /tmp/start_a32.XXXXXX.S)"
SUPPORT_C="$(mktemp /tmp/bintest_a32_support.XXXXXX.c)"
SUPPORT_O="$(mktemp /tmp/bintest_a32_support.XXXXXX.o)"
trap 'rm -f "$LINKER_SCRIPT" "$STARTUP_ASM" "$SUPPORT_C" "$SUPPORT_O"' EXIT

cat > "$LINKER_SCRIPT" << 'EOF'
ENTRY(_start)
MEMORY
{
    RAM (rwx) : ORIGIN = 0x10000, LENGTH = 8M
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

    .stack (NOLOAD) : {
        . = ALIGN(8);
        . = . + 64K;
        __stack_top = .;
    } > RAM
}
EOF

cat > "$STARTUP_ASM" << 'EOF'
.syntax unified
.arm
.section .text
.global _start
.type _start, %function
_start:
    ldr sp, =__stack_top

    ldr r0, =__bss_start
    ldr r1, =__bss_end
    mov r2, #0
1:
    cmp r0, r1
    bge 2f
    str r2, [r0], #4
    b 1b
2:
    bl test_main

    mov r7, #248
    svc #0
    b .
.size _start, . - _start
EOF

cat > "$SUPPORT_C" << 'EOF'
typedef unsigned long size_t;

void* memcpy(void* dst, const void* src, size_t n) {
    unsigned char* d = (unsigned char*)dst;
    const unsigned char* s = (const unsigned char*)src;
    for (size_t i = 0; i < n; ++i) d[i] = s[i];
    return dst;
}

void* memset(void* dst, int c, size_t n) {
    unsigned char* d = (unsigned char*)dst;
    for (size_t i = 0; i < n; ++i) d[i] = (unsigned char)c;
    return dst;
}

void* memmove(void* dst, const void* src, size_t n) {
    unsigned char* d = (unsigned char*)dst;
    const unsigned char* s = (const unsigned char*)src;
    if (d < s) {
        for (size_t i = 0; i < n; ++i) d[i] = s[i];
    } else if (d > s) {
        for (size_t i = n; i > 0; --i) d[i - 1] = s[i - 1];
    }
    return dst;
}

int memcmp(const void* a, const void* b, size_t n) {
    const unsigned char* pa = (const unsigned char*)a;
    const unsigned char* pb = (const unsigned char*)b;
    for (size_t i = 0; i < n; ++i) {
        if (pa[i] != pb[i]) return (int)pa[i] - (int)pb[i];
    }
    return 0;
}

void __aeabi_memcpy(void* dst, const void* src, size_t n) {
    memcpy(dst, src, n);
}

void __aeabi_memcpy4(void* dst, const void* src, size_t n) {
    memcpy(dst, src, n);
}

void __aeabi_memcpy8(void* dst, const void* src, size_t n) {
    memcpy(dst, src, n);
}

void __aeabi_memmove(void* dst, const void* src, size_t n) {
    memmove(dst, src, n);
}

void __aeabi_memset(void* dst, size_t n, int c) {
    memset(dst, c, n);
}

void __aeabi_memclr(void* dst, size_t n) {
    memset(dst, 0, n);
}
EOF

$CC $CFLAGS -c "$SUPPORT_C" -o "$SUPPORT_O"

build_test() {
    local src="$1"
    local out="$2"

    local dir ext compiler
    dir=$(dirname "$out")
    mkdir -p "$dir"

    ext="${src##*.}"
    compiler="$CC"
    if [ "$ext" = "cpp" ] || [ "$ext" = "cxx" ]; then
        compiler="$CXX"
    fi

    $compiler $CFLAGS -T "$LINKER_SCRIPT" "$STARTUP_ASM" "$src" "$SUPPORT_C" -o "$out" -lgcc
}

should_skip_a32() {
    local name="$1"
    case "$name" in
        a64_*) return 0 ;;
    esac
    return 1
}

echo "Building A32 binary tests..."

count=0
failed=0

for group_dir in "${SRC_DIR}"/*; do
    [ -d "$group_dir" ] || continue
    group="$(basename "$group_dir")"
    case "$group" in
        simde) continue ;;
    esac

    while IFS= read -r -d '' src; do
        name="$(basename "${src%.*}")"
        if should_skip_a32 "$name"; then
            continue
        fi
        out="${OUT_DIR}/${group}/${name}.elf"
        echo "  Building: ${group}/${name}"
        if build_test "$src" "$out" 2>&1; then
            count=$((count + 1))
        else
            echo "    FAILED to build"
            failed=$((failed + 1))
        fi
    done < <(find "$group_dir" -maxdepth 1 \( -name '*.c' -o -name '*.cpp' -o -name '*.cxx' \) -print0 | sort -z)
done

echo
echo "Built $count tests, $failed failures"
[ "$failed" -eq 0 ]
