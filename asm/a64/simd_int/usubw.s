/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000001000000010000000100000001"
}
*/
// Test: USUBW Vd.4S, Vn.4S, Vm.4H - Unsigned Subtract Wide
// Subtracts widened elements from existing elements

.text
.global _start
_start:
    mov w0, #2
    dup v0.4s, w0
    
    mov w1, #1
    dup v1.4h, w1
    
    // USUBW: unsigned subtract wide (4S - 4H -> 4S)
    // 2 - 1 = 1 for each element
    usubw v0.4s, v0.4s, v1.4h
    
    brk #0
