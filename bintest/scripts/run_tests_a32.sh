#!/bin/bash
# Run all A32 binary tests through dynarmic A32 JIT runner

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINTEST_DIR="$(dirname "$SCRIPT_DIR")"
ROOT_DIR="$(cd "${BINTEST_DIR}/.." && pwd)"

RUNNER="${1:-${ROOT_DIR}/build/dynarmic_bintest_a32}"
TESTS_DIR="${2:-${BINTEST_DIR}/out/a32}"

if [ ! -f "$RUNNER" ]; then
    echo "Runner not found: $RUNNER"
    echo "Please build dynarmic_bintest_a32 first"
    exit 1
fi

if [ ! -d "$TESTS_DIR" ]; then
    echo "A32 test directory not found: $TESTS_DIR"
    echo "Please build tests with build_tests_a32.sh first"
    exit 1
fi

"$RUNNER" "$TESTS_DIR"
