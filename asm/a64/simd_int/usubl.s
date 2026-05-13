/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000001000000010000000100000001"
}
*/
// Test: USUBL Vd.4S, Vn.4H, Vm.4H - Unsigned Subtract Long
// Widens and subtracts elements

.text
.global _start
_start:
    mov w0, #2
    dup v0.4h, w0
    mov w1, #1
    dup v1.4h, w1
    
    // USUBL: unsigned subtract long (4H -> 4S)
    // 2 - 1 = 1 for each element
    usubl v0.4s, v0.4h, v1.4h
    
    brk #0
