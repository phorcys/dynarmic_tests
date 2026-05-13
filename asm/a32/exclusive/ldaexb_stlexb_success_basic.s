/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000011",
    "R1": "0x00000000",
    "R2": "0x00000022",
    "R3": "0x00000022"
  }
}
*/
.arch armv8-a
.text
.global _start
_start:
    sub sp, sp, #16
    mov r4, #0x11
    strb r4, [sp]

    mov r5, sp
    ldaexb r0, [r5]
    mov r2, #0x22
    stlexb r1, r2, [r5]
    ldrb r3, [sp]

    add sp, sp, #16
    bkpt #0
