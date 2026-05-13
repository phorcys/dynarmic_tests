/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234"
  }
}
*/
// Test: LDTR - Load Register (unprivileged)

.text
.global _start
_start:
    sub sp, sp, #32
    
    // Store a value
    mov x0, #0x1234
    str x0, [sp]
    
    // Clear register
    mov x0, #0
    
    // Load unprivileged
    ldtr x0, [sp]
    
    add sp, sp, #32

    brk #0
