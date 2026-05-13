/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0x00000000",
    "R3": "0x00000024"
  }
}
*/
.arch armv8-a
.text
.global _start
_start:
    sub sp, sp, #16
    mov r0, sp

    mov r3, #0x24
    str r3, [r0]
    mov r1, #0x42

    ldaex r3, [r0]
    stlex r2, r1, [r0]

    add sp, sp, #16

    bkpt #0
