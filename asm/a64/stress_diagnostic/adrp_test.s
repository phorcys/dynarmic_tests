/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000002" }
}
*/
// ADRP+ADD test - isolate the ADRP+ADD problem

.text
.global _start
_start:
    mov x0, #1
    
    // Test ADRP+ADD
    adrp x2, indirect_func
    add x2, x2, :lo12:indirect_func
    
    // Now X2 should hold address of indirect_func
    // Verify by calling with BLR
    blr x2
    // x0 = 2 now
    
    brk #0

indirect_func:
    add x0, x0, #1
    ret
