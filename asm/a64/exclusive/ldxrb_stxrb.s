/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000AB",
    "X1": "0x00000000000000AB",
    "X2": "0x00000000000000CD",
    "X3": "0x0000000000000000",
    "X4": "0x00000000000000CD",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: LDXRB/STXRB - exclusive load/store byte

.text
.global _start
_start:
    sub sp, sp, #16
    mov x0, #0xAB
    strb w0, [sp]
    
    ldxrb w1, [sp]
    mov w2, #0xCD
    stxrb w3, w2, [sp]
    // w3 = 0 (success), [sp] = 0xCD
    
    ldrb w4, [sp]
    mov x5, #0
    mov x6, #0
    mov x7, #0
    add sp, sp, #16

    brk #0
