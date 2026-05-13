/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000002" }
}
*/
// ADRP+ADD+BLR test - simplified
// Tests if ADRP+ADD correctly computes function address for BLR

.text
.global _start
_start:
    mov x0, #1
    
    // Use ADRP+ADD to compute address
    adrp x2, indirect_func
    add x2, x2, :lo12:indirect_func
    
    // Use ADR to get the same address for comparison
    adr x3, indirect_func
    
    // Compare - they should be equal
    cmp x2, x3
    b.ne fail
    
    // If equal, call the function
    blr x2
    // x0 = 2 now
    
    brk #0

fail:
    // X0 = 0xFF to indicate ADRP+ADD gave wrong address
    mov x0, #255
    brk #0

indirect_func:
    add x0, x0, #1
    ret
