/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234"
  }
}
*/
// Test: LDXRH - Load Exclusive Register Halfword

.text
.global _start
_start:
    sub sp, sp, #32
    
    mov x0, #0x1234
    strh w0, [sp]
    
    mov x0, #0
    ldxrh w0, [sp]
    
    add sp, sp, #32

    brk #0
