/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x000000000000FFFF",
    "X2": "0x000000000000FFFF",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: BFI - Bit Field Insert

.text
.global _start
_start:
    mov x0, #0x1234
    mov x1, #0xFFFF
    
    // BFI Xd, Xn, #lsb, #width - insert width bits from Xn into Xd at position lsb
    // BFI is an alias for BFM where we insert bits
    mov x2, #0
    bfi x2, x1, #0, #16      // Insert 16 bits from x1 into x2 at bit 0
    
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
