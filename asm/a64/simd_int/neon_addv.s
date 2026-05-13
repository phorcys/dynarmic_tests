/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000004000000030000000200000001"
}
*/
// Test: NEON add across vector - ADDV Vd.S, Vn.4S
// Add all elements in vector

.text
.global _start
_start:
    // Create vector [1, 2, 3, 4]
    movi v0.4s, #1, lsl #0
    // Can't use movi for different values, use memory
    
    // Let's use dup for simplicity
    movi v0.4s, #1      // [1, 1, 1, 1]
    
    // ADDV sums all elements: 1+1+1+1 = 4
    addv s0, v0.4s
    
    // S0 = 4, upper bits of V0 are undefined

    brk #0
