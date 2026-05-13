/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000078"
  }
}
*/
// Test: LDXRB - Load Exclusive Register Byte

.text
.global _start
_start:
    sub sp, sp, #32
    
    mov x0, #0x78
    strb w0, [sp]
    
    mov x0, #0
    ldxrb w0, [sp]
    
    add sp, sp, #32

    brk #0
