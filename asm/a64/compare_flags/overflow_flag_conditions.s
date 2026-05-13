/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000000"
  }
}
*/
.text
.global _start
_start:
    // Test VS (V==1) and VC (V==0)

    // Test 1: V=0 (VS false, VC true)
    // NZCV: N=0, Z=0, C=0, V=0 -> 0x00000000
    mov x10, #0x00000000
    msr nzcv, x10

    mov x11, #1
    mov x12, #0

    csel x0, x11, x12, vs   // VS false (V=0): x0 = 0
    csel x1, x11, x12, vc   // VC true (V=0): x1 = 1

    // Test 2: V=1 (VS true, VC false)
    // NZCV: N=0, Z=0, C=0, V=1 -> 0x10000000
    mov x10, #0x10000000
    msr nzcv, x10

    csel x2, x11, x12, vs   // VS true (V=1): x2 = 1
    csel x3, x11, x12, vc   // VC false (V=1): x3 = 0

    brk #0
