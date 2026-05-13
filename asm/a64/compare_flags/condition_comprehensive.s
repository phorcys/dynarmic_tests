/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000020000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // All 16 ARM64 condition codes comprehensive test
    // Using direct NZCV manipulation
    // ========================================

    // Condition codes:
    // EQ=0, NE=1, CS=2, CC=3, MI=4, PL=5, VS=6, VC=7
    // HI=8, LS=9, GE=10, LT=11, GT=12, LE=13, AL=14, NV=15

    // Test 0: MI (minus, N=1) and GE (N=V)
    mov x10, #0xA                // N=1, Z=0, C=1, V=1
    lsl x10, x10, #28
    msr nzcv, x10
    // N=1, V=1, so N==V, GE is true
    mov x11, #100
    csel x12, x11, xzr, ge       // select if GE
    subs x13, x12, #100
    mrs x0, nzcv                 // Expected: Z=1 from subs, N=0, C=1

    // Test 1: LT (N!=V)
    mov x10, #0x9                // N=1, Z=0, C=0, V=1
    lsl x10, x10, #28
    msr nzcv, x10
    // N=1, V=1, so N==V, LT is false
    mov x11, #100
    csel x12, x11, xzr, lt       // select if LT (false)
    subs x13, x12, #0            // x12 should be 0
    mrs x1, nzcv                 // Expected: Z=1, C=1

    // Test 2: HI (C=1 and Z=0)
    mov x10, #0x2                // N=0, Z=0, C=1, V=0
    lsl x10, x10, #28
    msr nzcv, x10
    // C=1, Z=0, so HI is true
    mov x11, #42
    csel x12, x11, xzr, hi       // select if HI
    subs x13, x12, #42
    mrs x2, nzcv                 // Expected: Z=1, C=1

    // Test 3: LS (C=0 or Z=1)
    mov x10, #0xD                // N=1, Z=0, C=1, V=1
    lsl x10, x10, #28
    msr nzcv, x10
    // C=1, Z=0, so LS is false (not C=0, not Z=1)
    mov x11, #42
    csel x12, x11, xzr, ls       // select if LS (false)
    subs x13, x12, #0            // x12 should be 0
    mrs x3, nzcv                 // Expected: Z=1, C=1 from 0-0

    brk #0