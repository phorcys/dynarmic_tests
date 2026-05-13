/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000001",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000001",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000001"
  }
}
*/
.text
.global _start
_start:
    // Test N!=V case (signed overflow/underflow)
    // This tests LT true, GE false conditions

    // Test 1: N=1, Z=0, C=1, V=0
    // GE: N==V -> 1==0 -> false
    // LT: N!=V -> 1!=0 -> true
    // GT: Z==0 && N==V -> false (N!=V)
    // LE: Z==1 || N!=V -> true (N!=V)
    mov x10, #0x80000000
    msr nzcv, x10

    mov x11, #1
    mov x12, #0

    csel x0, x11, x12, ge   // GE false: x0 = 0
    csel x1, x11, x12, lt   // LT true: x1 = 1
    csel x2, x11, x12, gt   // GT false: x2 = 0
    csel x3, x11, x12, le   // LE true: x3 = 1

    // Test 2: N=0, Z=0, C=0, V=1
    // GE: N==V -> 0==1 -> false
    // LT: N!=V -> 0!=1 -> true
    // GT: Z==0 && N==V -> false (N!=V)
    // LE: Z==1 || N!=V -> true (N!=V)
    mov x10, #0x10000000    // N=0, Z=0, C=0, V=1
    msr nzcv, x10

    csel x4, x11, x12, ge   // GE false: x4 = 0
    csel x5, x11, x12, lt   // LT true: x5 = 1
    csel x6, x11, x12, gt   // GT false: x6 = 0
    csel x7, x11, x12, le   // LE true: x7 = 1

    brk #0
