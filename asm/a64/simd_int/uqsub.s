/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000020000000000000002"
}
*/
// Test: UQSUB Vd.4S, Vn.4S, Vm.4S - Saturating Subtract (unsigned)
// Subtracts with saturation to unsigned range (minimum 0)

.text
.global _start
_start:
    mov w0, #5
    dup v0.4s, w0
    mov w1, #3
    dup v1.4s, w1
    
    // UQSUB: saturating subtract (unsigned)
    // 5 - 3 = 2 (no saturation)
    uqsub v0.4s, v0.4s, v1.4s
    
    brk #0
