/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x0000000000001234",
    "X2": "0x0000000000005678",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000005678",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: LDXRH/STXRH - exclusive load/store halfword

.text
.global _start
_start:
    sub sp, sp, #16
    mov x0, #0x1234
    strh w0, [sp]
    
    ldxrh w1, [sp]
    mov w2, #0x5678
    stxrh w3, w2, [sp]
    // w3 = 0 (success), [sp] = 0x5678
    
    ldrh w4, [sp]
    mov x5, #0
    mov x6, #0
    mov x7, #0
    add sp, sp, #16

    brk #0
