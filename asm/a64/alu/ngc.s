/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001",
    "X2": "0xFFFFFFFFFFFFFFFF",
    "X3": "0x0000000000000005",
    "X4": "0xFFFFFFFFFFFFFFFA"
  }
}
*/
// Test: NGC - Negate with Carry
// NGC Xd, Xm => Xd = 0 - Xm - (1 - C)

.text
.global _start
_start:
    // Set C=0 (borrow) first: 0 - 1
    mov x0, #0
    mov x1, #1
    subs x2, x0, x1      // C=0 (borrow occurred)
    
    // NGC: 0 - 5 - (1 - 0) = -6
    mov x3, #5
    ngc x4, x3           // x4 = 0 - 5 - 1 = -6 = 0xFFFFFFFFFFFFFFFA

    brk #0