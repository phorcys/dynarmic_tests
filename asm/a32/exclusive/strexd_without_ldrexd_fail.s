/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x9ABCDEF0",
    "R7": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    ldr r4, =0x12345678
    ldr r5, =0x9ABCDEF0
    strd r4, r5, [sp]

    mov r6, sp
    ldr r4, =0x11111111
    ldr r5, =0x22222222
    strexd r7, r4, r5, [r6]
    ldrd r0, r1, [sp]

    add sp, sp, #16
    bkpt #0
