/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000002" }
}
*/
// ADRP + ADD with known offset, then BLR

.text
.global _start
_start:
    mov x0, #1
    
    // Use ADR to get exact address (works)
    adr x2, indirect_func
    blr x2
    // x0 = 2 now
    
    brk #0

indirect_func:
    add x0, x0, #1
    ret
