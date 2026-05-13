/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000B0000000",
    "X1": "0x0000000060000000",
    "X2": "0x00000000F0000000",
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
    // All 16 conditions with custom NZCV values
    // Using MSR to set NZCV directly
    // ========================================

    // Test 0: N=1, Z=0, C=1, V=1 = 0xB (MI condition true)
    mov x10, #0xB
    lsl x10, x10, #28            // 0xB0000000
    msr nzcv, x10                // set NZCV
    mrs x0, nzcv                 // Expected: same as set = 0xB0000000

    // Test 1: N=1, Z=0, C=1, V=1, test CS (C=1)
    mov x10, #0xB
    lsl x10, x10, #28
    msr nzcv, x10
    mov x11, #1
    csel x12, x11, xzr, cs       // select if CS (C=1)
    subs x13, x12, #1            // verify, Z=1, C=1
    mrs x1, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    // Test 2: N=1, Z=1, C=1, V=1 = 0xF
    mov x10, #0xF
    lsl x10, x10, #28
    msr nzcv, x10
    mrs x2, nzcv                 // Expected: 0xF0000000

    // Test 3: N=1, Z=0, C=1, V=1, test GT (Z=0 and N=V)
    // N=1, V=1, so N==V, and Z=0, so GT is true
    mov x10, #0xB                // N=1, Z=0, C=1, V=1
    lsl x10, x10, #28
    msr nzcv, x10
    mov x11, #42
    csel x12, x11, xzr, gt       // GT: Z=0 and N=V, here N=1, V=1, so true
    subs x13, x12, #42           // Z=1, C=1
    mrs x3, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    brk #0