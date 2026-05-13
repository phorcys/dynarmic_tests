/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000001000000010000000100000001"
}
*/
// Test: NEON min across vector - UMINV Vd.S, Vn.4S
// Find minimum element in vector (unsigned)

.text
.global _start
_start:
    // Create vector [1, 1, 1, 1]
    movi v0.4s, #1
    
    // UMINV finds minimum: min(1,1,1,1) = 1
    uminv s0, v0.4s

    brk #0