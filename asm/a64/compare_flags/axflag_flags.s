/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000",
    "X1": "0x20000000",
    "X2": "0x40000000",
    "X3": "0x60000000",
    "X4": "0x00000000",
    "X5": "0x20000000",
    "X6": "0x40000000",
    "X7": "0x60000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // AXFLAG - Convert ARM NZCV to x86 EFLAGS format
    // 
    // Based on QEMU verified behavior:
    // If N=0: output = input (unchanged)
    // If N=1: output = input with N cleared
    // 
    // This converts ARM condition flags to x86 format:
    // ARM N flag is inverted for x86 compatibility
    // ========================================

    // Test 0: NZCV = 0x00000000 (all clear)
    // N=0 -> unchanged
    msr nzcv, xzr
    axflag
    mrs x0, nzcv              // Expected: 0x00000000

    // Test 1: NZCV = 0x20000000 (C=1)
    // N=0 -> unchanged
    msr nzcv, xzr
    mov x20, #0x20000000
    msr nzcv, x20
    axflag
    mrs x1, nzcv              // Expected: 0x20000000

    // Test 2: NZCV = 0x40000000 (Z=1)
    // N=0 -> unchanged
    msr nzcv, xzr
    mov x20, #0x40000000
    msr nzcv, x20
    axflag
    mrs x2, nzcv              // Expected: 0x40000000

    // Test 3: NZCV = 0x60000000 (Z=1, C=1)
    // N=0 -> unchanged
    msr nzcv, xzr
    mov x20, #0x60000000
    msr nzcv, x20
    axflag
    mrs x3, nzcv              // Expected: 0x60000000

    // Test 4: NZCV = 0x80000000 (N=1)
    // N=1 -> clear N
    msr nzcv, xzr
    mov x20, #0x80000000
    msr nzcv, x20
    axflag
    mrs x4, nzcv              // Expected: 0x00000000 (N cleared)

    // Test 5: NZCV = 0xA0000000 (N=1, C=1)
    // N=1 -> clear N, keep C
    msr nzcv, xzr
    mov x20, #0xA0000000
    msr nzcv, x20
    axflag
    mrs x5, nzcv              // Expected: 0x20000000 (N cleared, C kept)

    // Test 6: NZCV = 0xC0000000 (N=1, Z=1)
    // N=1 -> clear N, keep Z
    msr nzcv, xzr
    mov x20, #0xC0000000
    msr nzcv, x20
    axflag
    mrs x6, nzcv              // Expected: 0x40000000 (N cleared, Z kept)

    // Test 7: NZCV = 0xE0000000 (N=1, Z=1, C=1)
    // N=1 -> clear N, keep Z, C
    msr nzcv, xzr
    mov x20, #0xE0000000
    msr nzcv, x20
    axflag
    mrs x7, nzcv              // Expected: 0x60000000 (N cleared, Z, C kept)

    brk #0