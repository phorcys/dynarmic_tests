/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000002" }
}
*/
// BLR with RET test - isolate the problem

.text
.global _start
_start:
    mov x0, #1
    
    // Use ADR (short range) instead of ADRP+ADD
    adr x2, indirect_func
    blr x2
    // x0 = 2 now
    
    brk #0

indirect_func:
    add x0, x0, #1
    ret
