/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000004000000030000000200000001"
}
*/
// Test: SADDL Vd.4S, Vn.4H, Vm.4H - Signed Add Long
// Widens and adds elements

.text
.global _start
_start:
    mov w0, #1
    dup v0.4h, w0
    mov w1, #0
    dup v1.4h, w1
    mov w1, #1
    mov v0.h[1], w1
    mov w1, #2
    mov v0.h[2], w1
    mov w1, #3
    mov v0.h[3], w1
    
    // SADDL: signed add long (4H -> 4S)
    saddl v0.4s, v0.4h, v1.4h
    
    brk #0
