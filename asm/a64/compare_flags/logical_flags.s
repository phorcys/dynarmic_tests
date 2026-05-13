/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x80000000",
    "X2": "0x40000000",
    "X3": "0x80000000",
    "X4": "0x40000000"
  }
}
*/
// Test: ANDS - AND with Set Flags
// ANDS sets N and Z only (C=0, V=0)
// For logical ops: N = sign bit, Z = (result == 0), C = 0, V=0
// Note: ARM64 has no ORRS/EORS - only ANDS and BICS set flags

.text
.global _start
_start:
    // Test 1: ANDS with result = 0
    // 0 AND 0 = 0, N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov w11, #0
    mov w12, #0
    ands w13, w11, w12
    mrs x0, nzcv

    // Test 2: ANDS with negative result
    // 0x80000000 AND 0x80000000 = 0x80000000
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov w11, #0x80000000
    mov w12, #0x80000000
    ands w13, w11, w12
    mrs x1, nzcv

    // Test 3: ANDS with partial bits (result = 0)
    // 0x55555555 AND 0xAAAAAAAA = 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov w11, #0x55555555
    mov w12, #0xAAAAAAAA
    ands w13, w11, w12
    mrs x2, nzcv

    // Test 4: ANDS preserving all bits
    // 0xFFFFFFFF AND 0xFFFFFFFF = 0xFFFFFFFF
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov w11, #-1
    mov w12, #-1
    ands w13, w11, w12
    mrs x3, nzcv

    // Test 5: ANDS with mixed values
    // 0xF0F0F0F0 AND 0x0F0F0F0F = 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov w11, #0xF0F0F0F0
    mov w12, #0x0F0F0F0F
    ands w13, w11, w12
    mrs x4, nzcv

    brk #0