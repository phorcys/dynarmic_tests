/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000080000000",
    "X5": "0x0000000000000000"
  }
}
*/
.text
.global _start
_start:
    // Test shift operations with flags update using shifted register form

    // Test 1: ADDS with LSL shift
    mov w11, #1
    adds w12, wzr, w11, lsl #30   // 0 + (1 << 30) = 0x40000000, flags: N=0, Z=0, C=0
    mrs x0, nzcv
    // Expected: N=0, Z=0, C=0, V=0 -> 0x00000000

    // Test 2: ADDS with LSL causing sign bit set
    mov w11, #1
    adds w12, wzr, w11, lsl #31   // 0 + (1 << 31) = 0x80000000, flags: N=1, Z=0, C=0
    mrs x1, nzcv
    // Expected: N=1, Z=0, C=0, V=0 -> 0x80000000

    // Test 3: CMN with LSR
    mov w11, #2
    cmn wzr, w11, lsr #1          // Compare 0 with (2 >> 1) = 1
    mrs x2, nzcv
    // Expected: 0 + 1 = 1, flags: N=0, Z=0, C=0, V=0 -> 0x00000000

    // Test 4: SUBS with ASR shift
    mov w11, #0x80000000          // negative number
    subs w12, wzr, w11, asr #31   // 0 - (0x80000000 >> 31) = 0 - 0xFFFFFFFF = 1
    mrs x3, nzcv
    // Expected: 0 - (-1) = 1, flags: N=0, Z=0, C=0, V=0 -> 0x00000000

    // Test 5: CMP with LSL
    mov w11, #1
    cmp w11, w11, lsl #1          // Compare 1 with (1 << 1) = 2, 1 - 2 = -1
    mrs x4, nzcv
    // Expected: 1 - 2 = -1, flags: N=1, Z=0, C=0, V=0 -> 0x80000000

    // Test 6: TST with LSL
    mov w11, #3
    tst w11, w11, lsl #1          // Test 3 & (3 << 1) = 3 & 6 = 2
    mrs x5, nzcv
    // Expected: N=0, Z=0, C=0, V=0 -> 0x00000000

    brk #0
