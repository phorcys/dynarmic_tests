/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: SBFM Xd, Xn, #immr, #imms - Signed Bit Field Move
// Moves bit field with sign extension

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0xFFFF
    
    // SBFM Xd, Xn, #immr, #imms
    // Extract bits [imms:immr] and sign extend
    // For sbfm x0, x1, #0, #11: extract bits [11:0] and sign extend
    // Bit 11 of 0xFFFF is 1, so sign extend to all 1s
    sbfm x0, x1, #0, #11

    brk #0
