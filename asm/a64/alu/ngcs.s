/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001",
    "X2": "0xFFFFFFFFFFFFFFFF",
    "X3": "0x000000000000000A",
    "X4": "0xFFFFFFFFFFFFFFF5"
  }
}
*/
// Test: NGCS - Negate with Carry and set flags

.text
.global _start
_start:
    // Set C=0 (borrow): 0 - 1
    mov x0, #0
    mov x1, #1
    subs x2, x0, x1      // C=0
    
    // NGCS: 0 - 10 - 1 = -11
    mov x3, #10
    ngcs x4, x3          // x4 = -11 = 0xFFFFFFFFFFFFFFF5

    brk #0