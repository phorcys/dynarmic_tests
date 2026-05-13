/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0x0000000000000003",
    "X2": "0x0000000000000006",
    "X3": "0x0000000000000007",
    "X4": "0x000000000000000A",
    "X5": "0x000000000000000B",
    "X6": "0x000000000000000E",
    "X7": "0x000000000000000F"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // ARM64 Condition Codes with CSEL (NZCV=0)
    // N=0, Z=0, C=0, V=0
    // ========================================

    // Set NZCV = 0x00000000
    msr nzcv, xzr

    // Test EQ (Z=1) - FALSE (Z=0)
    mov w20, #1
    mov w21, #2
    csel w22, w20, w21, eq     // result = 2
    mov x0, x22

    // Test NE (Z=0) - TRUE
    mov w20, #3
    mov w21, #4
    csel w22, w20, w21, ne     // result = 3
    mov x1, x22

    // Test CS (C=1) - FALSE (C=0)
    mov w20, #5
    mov w21, #6
    csel w22, w20, w21, cs     // result = 6
    mov x2, x22

    // Test CC (C=0) - TRUE
    mov w20, #7
    mov w21, #8
    csel w22, w20, w21, cc     // result = 7
    mov x3, x22

    // Test MI (N=1) - FALSE (N=0)
    mov w20, #9
    mov w21, #10
    csel w22, w20, w21, mi     // result = 10
    mov x4, x22

    // Test PL (N=0) - TRUE
    mov w20, #11
    mov w21, #12
    csel w22, w20, w21, pl     // result = 11
    mov x5, x22

    // Test VS (V=1) - FALSE (V=0)
    mov w20, #13
    mov w21, #14
    csel w22, w20, w21, vs     // result = 14
    mov x6, x22

    // Test VC (V=0) - TRUE
    mov w20, #15
    mov w21, #16
    csel w22, w20, w21, vc     // result = 15
    mov x7, x22

    brk #0
