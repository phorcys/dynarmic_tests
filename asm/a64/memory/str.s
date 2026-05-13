/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234"
  }
}
*/
// Test: STR Xn, [Xm] - store register

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #32
    
    // Store value at stack
    mov x0, #0x1234
    str x0, [sp]
    
    // Load back to verify
    ldr x0, [sp]
    
    add sp, sp, #32

    brk #0
