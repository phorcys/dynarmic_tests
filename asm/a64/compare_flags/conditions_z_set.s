/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000004",
    "X2": "0x0000000000000005",
    "X3": "0x0000000000000008",
    "X4": "0x000000000000000A",
    "X5": "0x0000000000000005",
    "X6": "0x000000000000000C",
    "X7": "0x0000000000000007"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // ARM64 Condition Codes with CSEL (NZCV=0x60000000)
    // N=0, Z=1, C=1, V=0
    // ========================================

    // Set NZCV = 0x60000000 (Z=1, C=1)
    mov x20, #0x60000000
    msr nzcv, x20

    // Test EQ (Z=1) - TRUE -> select w20=1
    mov w20, #1
    mov w21, #2
    csel w22, w20, w21, eq     // result = 1
    mov x0, x22

    // Test NE (Z=0) - FALSE -> select w21=4
    mov w20, #3
    mov w21, #4
    csel w22, w20, w21, ne     // result = 4
    mov x1, x22

    // Test CS (C=1) - TRUE -> select w20=5
    mov w20, #5
    mov w21, #6
    csel w22, w20, w21, cs     // result = 5
    mov x2, x22

    // Test CC (C=0) - FALSE -> select w21=8
    mov w20, #7
    mov w21, #8
    csel w22, w20, w21, cc     // result = 8
    mov x3, x22

    // Test HI (C=1 && Z=0) - FALSE (Z=1) -> select w21=10
    mov w20, #9
    mov w21, #10
    csel w22, w20, w21, hi     // result = 10
    mov x4, x22

    // Test LS (!(C=1 && Z=0)) - TRUE -> select w20=5
    mov w20, #5
    mov w21, #6
    csel w22, w20, w21, ls     // result = 5
    mov x5, x22

    // Test GT (Z=0 && N==V) - FALSE (Z=1) -> select w21=12
    mov w20, #11
    mov w21, #12
    csel w22, w20, w21, gt     // result = 12
    mov x6, x22

    // Test LE (!(Z=0 && N==V)) - TRUE -> select w20=7
    mov w20, #7
    mov w21, #8
    csel w22, w20, w21, le     // result = 7
    mov x7, x22

    brk #0