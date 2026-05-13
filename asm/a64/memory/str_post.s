/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000042",
    "X1": "0x0000000000000042"
  }
}
*/
// Test: STR (post-index) - Store Register with post-index

.text
.global _start
_start:
    mov x0, #0x42
    sub sp, sp, #16
    
    // Store with post-index (store, then sp += 16)
    str x0, [sp], #16
    
    // Now sp is back to original, reload from sp-16
    sub sp, sp, #16
    ldr x1, [sp]
    add sp, sp, #16

    brk #0
