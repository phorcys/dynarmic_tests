/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000FFF"
  }
}
*/
// Test: UBFM Xd, Xn, #immr, #imms - Unsigned Bit Field Move
// Moves bit field with zero extension

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0xFFFF
    
    // UBFM Xd, Xn, #immr, #imms
    // Extract bits [imms:immr] and zero extend
    ubfm x0, x1, #0, #11   // Extract bits [11:0]

    brk #0