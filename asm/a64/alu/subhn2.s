/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SUBHN2 Vd.8H, Vn.4S, Vm.4S - Subtract Narrowing High
// Subtracts and stores high half of result to high half of destination

.text
.global _start
_start:
    mov w0, #0
    dup v0.4s, w0      // Low half initialized to 0
    mov w0, #0x10000
    dup v1.4s, w0      // Values
    
    // SUBHN2: subtract and narrow high half
    // Result high half: 0x10000 - 0x10000 = 0
    subhn2 v0.8h, v1.4s, v1.4s
    
    brk #0
