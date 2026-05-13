/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000010000000000000001",
  "Q1": "0x00000000000000020000000000000002"
}
*/
// Test: UZP2 Vd.4S, Vn.4S, Vm.4S - Unzip vectors (odd elements)
// Extracts odd elements from two vectors

.text
.global _start
_start:
    // Create vectors with distinct values
    movi v0.4s, #1, lsl #0      // [1, 1, 1, 1]
    movi v1.4s, #2, lsl #0      // [2, 2, 2, 2]
    
    // UZP2: extract odd elements
    uzp2 v0.4s, v0.4s, v1.4s
    
    // Result depends on interleaving pattern

    brk #0
