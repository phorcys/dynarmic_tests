/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000010000000000000002"
}
*/
// Test: ZIP2 Vd.4S, Vn.4S, Vm.4S - Zip vectors (high halves)
// Interleaves high halves of two vectors

.text
.global _start
_start:
    // Create vectors with distinct values
    movi v0.4s, #1, lsl #0      // [1, 1, 1, 1]
    movi v1.4s, #2, lsl #0      // [2, 2, 2, 2]
    
    // ZIP2: interleave high halves
    zip2 v0.4s, v0.4s, v1.4s
    
    // Result: [1, 2, 1, 2] (interleaved high halves)

    brk #0
