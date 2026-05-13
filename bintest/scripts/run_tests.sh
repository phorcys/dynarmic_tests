#!/bin/bash
# Run all binary tests

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINTEST_DIR="$(dirname "$SCRIPT_DIR")"
ROOT_DIR="$(cd "${BINTEST_DIR}/.." && pwd)"

RUNNER="${1:-${ROOT_DIR}/build/dynarmic_bintest_a64}"
TESTS_DIR="${2:-${BINTEST_DIR}/out/a64}"

if [ ! -f "$RUNNER" ]; then
    echo "Runner not found: $RUNNER"
    echo "Please build dynarmic_bintest_a64 first"
    exit 1
fi

total_passed=0
total_failed=0

echo "dynarmic_bintest_runner"
echo "======================="
echo ""

for group in group1_basic group2_instructions group3_complex group4_vector group5_mixed crypto datastruct math scientific string workload; do
    group_dir="${TESTS_DIR}/${group}"
    if [ -d "$group_dir" ]; then
        echo "--- Group: $group ---"
        "$RUNNER" "$group_dir"
        echo ""
    fi
done

echo "======================="
echo "All tests completed"
