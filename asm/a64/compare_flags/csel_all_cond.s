/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000001",
    "X4": "0x0000000000000001",
    "X5": "0x0000000000000001",
    "X6": "0x0000000000000001",
    "X7": "0x0000000000000001"
  }
}
*/
// Test: CSEL - all condition codes
// All conditions evaluate to true, selecting x1 (value 1)

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1               // true value
    mov x2, #2               // false value

    // EQ: Z==1 (equal)
    cmp x0, #0               // Z=1
    csel x2, x1, x2, eq      // x2 = 1 (took x1)

    // NE: Z==0 (not equal)
    cmp x0, #1               // Z=0
    csel x3, x1, x2, ne      // x3 = 1 (took x1)

    // CS/HS: C=1 (unsigned higher or same)
    mov x0, #0
    cmp x0, #1               // C=1 (borrow occurred)
    csel x4, x1, x2, cs      // x4 = 1

    // CC/LO: C=0 (unsigned lower)
    mov x0, #1
    cmp x0, #0               // C=0 (no borrow)
    csel x5, x1, x2, cc      // x5 = 1

    // MI: N=1 (negative)
    movn x0, #0              // x0 = -1
    cmp x0, #0               // N=1
    csel x6, x1, x2, mi      // x6 = 1

    // PL: N=0 (positive or zero)
    mov x0, #1
    cmp x0, #0               // N=0
    csel x7, x1, x2, pl      // x7 = 1

    brk #0