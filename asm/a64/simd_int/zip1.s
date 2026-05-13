/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000010000000000000001",
  "Q1": "0x00000000000000020000000000000002"
}
*/
// Test: ZIP1 Vd.4S, Vn.4S, Vm.4S - Zip vectors (low halves)
// Interleaves low halves of two vectors

.text
.global _start
_start:
    // Create vectors with distinct values
    movi v0.4s, #1, lsl #0      // [1, 1, 1, 1]
    movi v1.4s, #2, lsl #0      // [2, 2, 2, 2]
    
    // ZIP1: interleave low halves
    zip1 v0.4s, v0.4s, v1.4s
    
    // Result: [1, 2, 1, 2] (interleaved low halves)

    brk #0
