/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001FFF"
  }
}
*/
// Test: BFM Xd, Xn, #immr, #imms - Bit Field Move
// Moves bit field from source to destination

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0xFFFF
    
    // BFM: move bit field
    // BFM Xd, Xn, #immr, #imms
    // immr = rotation, imms = width - 1
    bfm x0, x1, #0, #12

    brk #0