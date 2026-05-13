/* CONFIG
{
  "Match": "All",
  "Q0": "0x000000000000002A000000000000002A"
}
*/
// Test: EXT Vd.16B, Vn.16B, Vm.16B, #imm - Extract vector from pair
// Extracts bytes from a pair of vectors

.text
.global _start
_start:
    movi v0.16b, #0
    movi v1.16b, #42
    
    // EXT: extract bytes starting at index 8 from v1:v0
    ext v0.16b, v0.16b, v1.16b, #8
    
    // Result: low 8 bytes from v1 (all 42s)

    brk #0
