/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FFFF",
    "X1": "0x00000000000000FF",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: UBFM - Unsigned Bit Field Move

.text
.global _start
_start:
    mov x0, #0xFFFF
    
    // UBFM Xd, Xn, #immr, #imms
    // This extracts bits from Xn and puts them in Xd
    ubfm x1, x0, #0, #7      // Extract bits 0-7
    
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
