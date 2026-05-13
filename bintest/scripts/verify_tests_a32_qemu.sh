#!/bin/bash
# Verify all compiled A32 binary tests with qemu-arm

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINTEST_DIR="$(dirname "$SCRIPT_DIR")"
TESTS_DIR="${1:-${BINTEST_DIR}/out/a32}"

if ! command -v qemu-arm >/dev/null 2>&1; then
    echo "qemu-arm not found"
    exit 1
fi

if [ ! -d "$TESTS_DIR" ]; then
    echo "A32 test directory not found: $TESTS_DIR"
    echo "Please build tests with build_tests_a32.sh first"
    exit 1
fi

total=0
failed=0

while IFS= read -r -d '' elf; do
    total=$((total + 1))
    echo "Testing: ${elf#$TESTS_DIR/} ..."
    if ! qemu-arm "$elf" >/tmp/qemu_a32_bintest.out 2>/tmp/qemu_a32_bintest.err; then
        failed=$((failed + 1))
        echo "  FAILED"
        sed -n '1,20p' /tmp/qemu_a32_bintest.out
        sed -n '1,20p' /tmp/qemu_a32_bintest.err >&2
    fi
done < <(find "$TESTS_DIR" -name '*.elf' -print0 | sort -z)

echo
echo "Summary: $total total, $failed failed"
[ "$failed" -eq 0 ]
