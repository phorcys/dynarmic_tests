/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00001234",
    "R1": "0x00000000",
    "R2": "0x00005678",
    "R3": "0x00005678"
  }
}
*/
.arch armv8-a
.text
.global _start
_start:
    sub sp, sp, #16
    movw r4, #0x1234
    strh r4, [sp]

    mov r5, sp
    ldaexh r0, [r5]
    movw r2, #0x5678
    stlexh r1, r2, [r5]
    ldrh r3, [sp]

    add sp, sp, #16
    bkpt #0
