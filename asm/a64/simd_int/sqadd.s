/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000000000000000007F"
}
*/
// Test: SQADD Vd.4S, Vn.4S, Vm.4S - Saturating Add (signed)
// Adds with saturation to signed range

.text
.global _start
_start:
    mov w0, #127
    dup v0.4s, w0
    mov w1, #0
    dup v1.4s, w1
    
    // SQADD: saturating add (signed)
    // 127 + 0 = 127 (no saturation)
    sqadd v0.4s, v0.4s, v1.4s
    
    brk #0
