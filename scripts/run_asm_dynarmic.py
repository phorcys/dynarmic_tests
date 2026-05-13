#!/usr/bin/env python3
import argparse
import subprocess
import sys
from pathlib import Path


def iter_tests(path: Path):
    if path.is_file():
        if path.suffix in (".s", ".asm"):
            return [path]
        raise SystemExit(f"not an asm test file: {path}")
    if path.is_dir():
        return sorted(p for p in path.rglob("*") if p.suffix in (".s", ".asm"))
    raise SystemExit(f"test path does not exist: {path}")


def status_from_output(output: str, returncode: int) -> str:
    if returncode == 0 and "KNOWN FAILURE" in output:
        return "known"
    if returncode == 0 and "PASSED" in output:
        return "passed"
    return "failed"


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Run Dynarmic asm tests one process per source file."
    )
    parser.add_argument("--runner", required=True, help="dynarmic_asmtest executable")
    parser.add_argument("--tests", required=True, help="asm test file or directory")
    parser.add_argument("--timeout", type=float, default=30.0, help="per-test timeout in seconds")
    args = parser.parse_args()

    runner = Path(args.runner)
    tests_root = Path(args.tests)
    tests = iter_tests(tests_root)
    if not tests:
        print("No asm tests found", file=sys.stderr)
        return 1

    print("Dynarmic ASM Test Runner")
    print(f"Runner: {runner}")
    print(f"Input: {tests_root}")
    print(f"Found {len(tests)} test files")
    print()

    passed = 0
    failed = 0
    known = 0

    base = tests_root if tests_root.is_dir() else tests_root.parent
    for test in tests:
        rel = test.relative_to(base)
        print(f"Testing: {str(rel):<50} ... ", end="", flush=True)
        try:
            proc = subprocess.run(
                [str(runner), str(test)],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                timeout=args.timeout,
            )
            output = proc.stdout
            returncode = proc.returncode
        except subprocess.TimeoutExpired as e:
            output = e.stdout or ""
            returncode = -1
            print("FAILED")
            print(f"  Timeout after {args.timeout:g}s")
            if output:
                for line in output.splitlines()[:20]:
                    print(f"  {line}")
            failed += 1
            continue

        status = status_from_output(output, returncode)
        if status == "passed":
            print("PASSED")
            passed += 1
        elif status == "known":
            print("KNOWN FAILURE")
            known += 1
        else:
            print("FAILED")
            if returncode != 0:
                print(f"  exit status: {returncode}")
            interesting = [
                line for line in output.splitlines()
                if "FAILED" in line or "Unhandled" in line or "Exception" in line
                or "Error" in line or "expected" in line or "terminate" in line
            ]
            for line in (interesting or output.splitlines())[:20]:
                print(f"  {line}")
            failed += 1

    print()
    print("==================================================")
    print(f"Summary: {passed} passed, {failed} failed, {known} known failures")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
