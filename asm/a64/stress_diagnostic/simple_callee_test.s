/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x0000000000000000"
  }
}
*/
// Simple callee-saved register test
// Verifies X19-X28 preservation across a function call

.text
.global _start
_start:
    // Set callee-saved registers
    mov x19, #100
    mov x20, #200
    
    // Call a function
    bl simple_func
    
    // Verify X19 and X20
    // X0 = 0 if both preserved
    mov x0, #0
    
    cmp x19, #100
    cset x1, ne
    add x0, x0, x1
    
    cmp x20, #200
    cset x1, ne
    add x0, x0, x1
    
    brk #0

simple_func:
    ret
