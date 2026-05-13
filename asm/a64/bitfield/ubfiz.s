/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FFFF",
    "X1": "0x0000000000007FFF"
  }
}
*/
// Test: UBFIZ Xd, Xn, #lsb, #width - Unsigned Bit Field Insert in Zero
// Insert bit field from source into zero (no sign-extension)

.text
.global _start
_start:
    mov x0, #0
    
    // Insert unsigned bit field: take 16 bits from source, place at position 0
    mov x2, #0xFFFF
    ubfiz x0, x2, #0, #16
    // Take 16 bits from x2[15:0] = 0xFFFF
    // Place at position 0
    // Upper bits are zero
    // X0 = 0xFFFF

    // Test with shift
    mov x1, #0
    mov x2, #0x7FFF
    ubfiz x1, x2, #0, #15
    // Take 15 bits from x2[14:0] = 0x7FFF
    // Place at position 0
    // Upper bits are zero (unsigned, no sign extension)
    // X1 = 0x7FFF

    brk #0
