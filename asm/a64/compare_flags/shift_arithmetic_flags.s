/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000080000000",
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
    // Shift with flags from arithmetic
    // ========================================

    // Test 0: LSLS (logical shift left and set flags)
    mov x10, #1
    lsl x11, x10, #63       // shift to sign bit
    adds x12, x11, #0       // check result
    mrs x0, nzcv            // Expected: N=1 (0x80000000)

    // Test 1: ASRS (arithmetic shift right and set flags)
    mov x10, #1
    lsl x10, x10, #63       // x10 = INT64_MIN
    asr x11, x10, #1        // arithmetic shift right
    // INT64_MIN >> 1 = -4611686018427387904 (still negative)
    adds x12, x11, #0
    mrs x1, nzcv            // Expected: N=1 (0x80000000)

    // Test 2: LSRS (logical shift right and set flags)
    mov x10, #1
    lsl x10, x10, #63       // x10 = 0x8000000000000000
    lsr x11, x10, #1        // logical shift right
    // 0x8000000000000000 >> 1 = 0x4000000000000000
    mov x12, #1
    lsl x12, x12, #62       // x12 = 0x4000000000000000
    subs x13, x11, x12
    mrs x2, nzcv            // Expected: Z=1, C=1

    // Test 3: Shift with zero result
    mov x10, #1
    lsr x11, x10, #1        // 1 >> 1 = 0
    subs x12, x11, #0
    mrs x3, nzcv            // Expected: Z=1, C=1

    brk #0