/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000042",
    "X1": "0x0000000000000042"
  }
}
*/
// Test: STR (pre-index) - Store Register with pre-index

.text
.global _start
_start:
    mov x0, #0x42
    mov x1, #0
    
    // Store with pre-index (sp -= 16, then store)
    str x0, [sp, #-16]!
    
    // Load back
    ldr x1, [sp]
    add sp, sp, #16

    brk #0
