/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000042"
  }
}
*/
// Test: LDRB - Load Register Byte (zero-extend)

.text
.global _start
_start:
    // Store a byte value on stack
    mov x8, #0x42
    strb w8, [sp, #-16]!
    
    // Load the byte
    ldrb w0, [sp]
    
    add sp, sp, #16

    brk #0
