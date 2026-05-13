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
    // Signed comparison condition codes
    // ========================================

    // Test 0: GT (greater than, Z=0 && N=V)
    mov x10, #20
    mov x11, #10
    cmp x10, x11             // 20 > 10, N=0, V=0, Z=0
    cset x12, gt             // x12 = 1 if GT
    subs x13, x12, #1
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: LE (less than or equal, Z=1 || N!=V)
    mov x10, #10
    mov x11, #20
    cmp x10, x11             // 10 < 20, N=1, V=0
    cset x12, le             // x12 = 1 if LE (N!=V is true)
    subs x13, x12, #1
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: GE (greater than or equal, N=V)
    mov x10, #10
    mov x11, #10
    cmp x10, x11             // 10 == 10, Z=1, N=0, V=0
    cset x12, ge             // x12 = 1 if GE (N=V is true)
    subs x13, x12, #1
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: LT (less than, N!=V)
    mov x10, #10
    mov x11, #20
    cmp x10, x11             // 10 < 20, N=1, V=0
    cset x12, lt             // x12 = 1 if LT (N!=V is true)
    subs x13, x12, #1
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0
