/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000001000000010000000100000001"
}
*/
// Test: NEON max across vector - UMAXV Vd.S, Vn.4S
// Find maximum element in vector (unsigned)

.text
.global _start
_start:
    // Create vector [1, 1, 1, 1]
    movi v0.4s, #1
    
    // UMAXV finds maximum: max(1,1,1,1) = 1
    umaxv s0, v0.4s

    brk #0