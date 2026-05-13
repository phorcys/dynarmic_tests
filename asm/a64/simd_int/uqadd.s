/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000010000000000000001"
}
*/
// Test: UQADD Vd.4S, Vn.4S, Vm.4S - Saturating Add (unsigned)
// Adds with saturation to unsigned range

.text
.global _start
_start:
    mov w0, #0
    dup v0.4s, w0
    mov w1, #1
    dup v1.4s, w1
    
    // UQADD: saturating add (unsigned)
    // 0 + 1 = 1 (no saturation)
    uqadd v0.4s, v0.4s, v1.4s
    
    brk #0
