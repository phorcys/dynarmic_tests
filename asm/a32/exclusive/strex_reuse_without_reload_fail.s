/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x00000000",
    "R2": "0x00000001",
    "R3": "0x11111111"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    ldr r4, =0x12345678
    str r4, [sp]

    mov r5, sp
    ldrex r0, [r5]

    ldr r6, =0x11111111
    strex r1, r6, [r5]     @ first store succeeds

    ldr r6, =0x22222222
    strex r2, r6, [r5]     @ second store should fail without new LDREX
    ldr r3, [sp]

    add sp, sp, #16
    bkpt #0
