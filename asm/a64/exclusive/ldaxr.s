/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x0000000000001234"
  }
}
*/
// Test: LDAXR Xt, [Xn] - load-acquire exclusive register

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #32
    
    // Store value
    mov x0, #0x1234
    str x0, [sp]
    
    // LDAXR: load-acquire exclusive
    ldaxr x1, [sp]
    
    add sp, sp, #32

    brk #0
