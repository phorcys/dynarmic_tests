/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000002" }
}
*/
// RSB pollution test - minimal version
// Test BLR (indirect call) to see if it works

.text
.global _start
_start:
    mov x0, #1
    
    // Test BLR (indirect call)
    adrp x2, indirect_func
    add x2, x2, :lo12:indirect_func
    blr x2
    // x0 = 2 now
    
    brk #0

indirect_func:
    add x0, x0, #1
    ret
