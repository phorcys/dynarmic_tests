/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SQSUB Vd.4S, Vn.4S, Vm.4S - Saturating Subtract (signed)
// Subtracts with saturation to signed range

.text
.global _start
_start:
    mov w0, #0
    dup v0.4s, w0
    mov w1, #0
    dup v1.4s, w1
    
    // SQSUB: saturating subtract (signed)
    // 0 - 0 = 0 (no saturation)
    sqsub v0.4s, v0.4s, v1.4s
    
    brk #0
