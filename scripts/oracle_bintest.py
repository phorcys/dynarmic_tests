#!/usr/bin/env python3
import argparse
import subprocess
import sys
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate generated ELF tests with QEMU.")
    parser.add_argument("--qemu", required=True, help="qemu executable")
    parser.add_argument("--tests", required=True, help="directory containing .elf files")
    parser.add_argument("--name", default="bintest", help="summary name")
    parser.add_argument("--timeout", type=float, default=30.0, help="per-test timeout in seconds")
    args = parser.parse_args()

    tests_dir = Path(args.tests)
    if not tests_dir.is_dir():
        print(f"test directory not found: {tests_dir}", file=sys.stderr)
        return 2

    tests = sorted(tests_dir.rglob("*.elf"))
    if not tests:
        print(f"no ELF tests found in {tests_dir}", file=sys.stderr)
        return 2

    passed = 0
    failed = 0
    for elf in tests:
        rel = elf.relative_to(tests_dir)
        print(f"Testing: {rel} ... ", end="", flush=True)
        try:
            proc = subprocess.run(
                [args.qemu, str(elf)],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                timeout=args.timeout,
            )
        except subprocess.TimeoutExpired as e:
            print("FAILED")
            print(f"  timeout after {args.timeout:g}s")
            output = (e.stdout or "") + (e.stderr or "")
            for line in output.splitlines()[:20]:
                print(f"  {line}")
            failed += 1
            continue

        if proc.returncode == 0:
            print("PASSED")
            passed += 1
        else:
            print("FAILED")
            print(f"  exit status: {proc.returncode}")
            output = proc.stdout + proc.stderr
            for line in output.splitlines()[:20]:
                print(f"  {line}")
            failed += 1

    print()
    print(f"SUMMARY {args.name}: {passed} passed, {failed} failed")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
