/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A",
    "X1": "0x0000000000000005",
    "X2": "0x0000000000000005",
    "X3": "0x0000000000000005"
  }
}
*/
// Test: SBC - Subtract with Carry (borrow)
// SBC Xd, Xn, Xm => Xd = Xn - Xm - (1 - C)
// When C=1 (no borrow), SBC acts like SUB

.text
.global _start
_start:
    // First, do a SUB that sets C=1 (no borrow)
    // 10 - 5 = 5, C=1 (no borrow since 10 >= 5)
    mov x0, #10
    mov x1, #5
    subs x2, x0, x1      // x2 = 5, C=1
    
    // Now SBC: 10 - 5 - 0 = 5 (since C=1)
    sbc x3, x0, x1       // x3 = 10 - 5 - 0 = 5

    brk #0