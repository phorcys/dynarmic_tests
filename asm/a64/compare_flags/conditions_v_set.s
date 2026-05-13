/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000004",
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
    // ARM64 Condition Codes with CSEL (NZCV=0x10000000)
    // N=0, Z=0, C=0, V=1
    // 
    // When N=0, V=1: N!=V, so LT is true, GE is false
    // ========================================

    // Set NZCV = 0x10000000 (V=1)
    mov x20, #0x10000000
    msr nzcv, x20

    // Test VS (V=1) - TRUE -> select w20=1
    mov w20, #1
    mov w21, #2
    csel w22, w20, w21, vs     // result = 1
    mov x0, x22

    // Test VC (V=0) - FALSE -> select w21=4
    mov w20, #3
    mov w21, #4
    csel w22, w20, w21, vc     // result = 4
    mov x1, x22

    // Test GE (N==V) - FALSE (N=0, V=1, N!=V) -> select w21=6
    mov w20, #5
    mov w21, #6
    csel w22, w20, w21, ge     // result = 6
    mov x2, x22

    // Test LT (N!=V) - TRUE (N=0, V=1, N!=V) -> select w20=7
    mov w20, #7
    mov w21, #8
    csel w22, w20, w21, lt     // result = 7
    mov x3, x22

    // Test GT (Z=0 && N==V) - FALSE (N!=V) -> select w21=10
    mov w20, #9
    mov w21, #10
    csel w22, w20, w21, gt     // result = 10
    mov x4, x22

    // Test LE (!(Z=0 && N==V)) - TRUE -> select w20=11
    mov w20, #11
    mov w21, #12
    csel w22, w20, w21, le     // result = 11
    mov x5, x22

    // Test EQ (Z=1) - FALSE -> select w21=14
    mov w20, #13
    mov w21, #14
    csel w22, w20, w21, eq     // result = 14
    mov x6, x22

    // Test NE (Z=0) - TRUE -> select w20=15
    mov w20, #15
    mov w21, #16
    csel w22, w20, w21, ne     // result = 15
    mov x7, x22

    brk #0