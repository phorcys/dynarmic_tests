/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FFFF"
  }
}
*/
// Test: BFI Xd, Xn, #lsb, #width - Bit Field Insert
// Insert bit field from source into destination

.text
.global _start
_start:
    mov x0, #0
    
    // Insert 16 bits from source into destination at position 0
    mov x2, #0xFFFF
    bfi x0, x2, #0, #16
    // Take 16 bits from x2[15:0] = 0xFFFF
    // Insert into x0 at position 0
    // X0 = 0xFFFF

    brk #0
