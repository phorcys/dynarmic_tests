/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000060000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Exclusive operations with flags
    // ========================================

    // Test 0: Basic arithmetic with flags
    mov x10, #100
    subs x11, x10, #100
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: Basic arithmetic with flags
    mov x10, #200
    subs x11, x10, #200
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: CLREX (clear exclusive)
    clrex
    mov x10, #1
    subs x11, x10, #1
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: DMB (data memory barrier)
    dmb sy
    mov x10, #42
    subs x11, x10, #42
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0