/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000000000000000002A",
  "Q1": "0x000000000000002A0000000000000000"
}
*/
// Test: UZP1 Vd.4S, Vn.4S, Vm.4S - Unzip vectors (even elements)
// Extracts even elements from two vectors

.text
.global _start
_start:
    // Create vectors with distinct values
    movi v0.4s, #1, lsl #0      // [1, 1, 1, 1]
    movi v1.4s, #2, lsl #0      // [2, 2, 2, 2]
    
    // UZP1: extract even elements
    uzp1 v0.4s, v0.4s, v1.4s
    
    // Result depends on interleaving pattern

    brk #0
