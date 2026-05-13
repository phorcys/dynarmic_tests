/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000078",
    "R1": "0x00000056",
    "R2": "0x00005678",
    "R3": "0x00003456"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    mov r4, sp

    mov r5, #0x78
    strb r5, [r4, #0]
    mov r5, #0x56
    strb r5, [r4, #1]
    mov r5, #0x34
    strb r5, [r4, #2]

    ldrb r0, [r4, #0]
    ldrb r1, [r4, #1]
    ldrh r2, [r4, #0]
    ldrh r3, [r4, #1]

    add sp, sp, #16
    bkpt #0
