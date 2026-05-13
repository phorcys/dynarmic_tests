/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0x0000000000000003",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000001",
    "X4": "0xFFFFFFFFFFFFFFFF",
    "X5": "0x0000000000000008"
  }
}
*/
// Test: ADCS - Add with Carry and set flags
// ADCS Xd, Xn, Xm => Xd = Xn + Xm + C

.text
.global _start
_start:
    mov x0, #5
    mov x1, #3
    
    // First clear C flag: 0 - 1 sets C=0 (borrow)
    mov x2, #0
    mov x3, #1
    subs x4, x2, x3      // 0 - 1 = -1, C=0 (borrow)
    
    // ADCS: 5 + 3 + 0 = 8 (since C=0)
    adcs x5, x0, x1      // x5 = 8

    brk #0