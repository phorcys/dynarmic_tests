/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000001",
    "X4": "0x0000000000000001",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000001",
    "X7": "0x0000000000000000"
  }
}
*/
.text
.global _start
_start:
    // Test signed conditions GE, LT, GT, LE with different flag combinations

    // Test 1: N=0, Z=1, C=1, V=0
    // GE: N==V -> 0==0 -> true
    // LT: N!=V -> 0!=0 -> false
    // GT: Z==0 && N==V -> false (Z=1)
    // LE: Z==1 || N!=V -> true (Z=1)
    mov x10, #0x60000000
    msr nzcv, x10

    mov x11, #1
    mov x12, #0

    csel x0, x11, x12, ge   // GE true: x0 = 1
    csel x1, x11, x12, lt   // LT false: x1 = 0
    csel x2, x11, x12, gt   // GT false: x2 = 0
    csel x3, x11, x12, le   // LE true: x3 = 1

    // Test 2: N=1, Z=0, C=0, V=1
    // GE: N==V -> 1==1 -> true
    // LT: N!=V -> 1!=1 -> false
    // GT: Z==0 && N==V -> true (Z=0 and N==V)
    // LE: Z==1 || N!=V -> false (Z=0 and N==V)
    mov x10, #0x90000000    // N=1, Z=0, C=0, V=1
    msr nzcv, x10

    csel x4, x11, x12, ge   // GE true: x4 = 1
    csel x5, x11, x12, lt   // LT false: x5 = 0
    csel x6, x11, x12, gt   // GT true: x6 = 1
    csel x7, x11, x12, le   // LE false: x7 = 0

    brk #0