/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000003000000020000000100000000"
}
*/
// Test: SADDW Vd.4S, Vn.4S, Vm.4H - Signed Add Wide
// Adds widened elements to existing elements

.text
.global _start
_start:
    mov w0, #0
    dup v0.4s, w0
    mov w0, #1
    mov v0.s[1], w0
    mov w0, #2
    mov v0.s[2], w0
    
    mov w1, #0
    dup v1.4h, w1
    
    // SADDW: signed add wide (4S + 4H -> 4S)
    saddw v0.4s, v0.4s, v1.4h
    
    brk #0
