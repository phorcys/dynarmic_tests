/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000002000000020000000200000002"
}
*/
// Test: ADDHN2 Vd.8H, Vn.4S, Vm.4S - Add Narrowing High
// Adds and stores high half of result to high half of destination

.text
.global _start
_start:
    mov w0, #0x100
    dup v0.4s, w0      // Low half initialized
    mov w0, #0x10000
    dup v1.4s, w0      // High values to add
    
    // ADDHN2: add and narrow high half
    // Result high half: 0x10000 + 0x10000 = 0x20000 -> high half = 2
    addhn2 v0.8h, v1.4s, v1.4s
    
    brk #0
