/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000080",
    "R1": "0xFFFFFF80",
    "R2": "0x0000007F",
    "R3": "0x0000007F"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    mov r4, #0x80
    strb r4, [sp]
    mov r4, #0x7F
    strb r4, [sp, #1]

    ldrb r0, [sp]
    ldrsb r1, [sp]
    ldrb r2, [sp, #1]
    ldrsb r3, [sp, #1]

    add sp, sp, #16
    bkpt #0
