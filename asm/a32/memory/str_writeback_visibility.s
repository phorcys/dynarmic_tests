/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11111111",
    "R1": "0x00000004",
    "R2": "0x22222222",
    "R3": "0x00000008"
  }
}
*/
// Writeback visibility for STR pre/post indexed forms.

.text
.arm
.global _start
_start:
    sub sp, sp, #24

    ldr r0, =0x11111111
    mov r1, sp
    str r0, [r1, #4]!
    sub r1, r1, sp

    ldr r2, =0x22222222
    add r3, sp, #4
    str r2, [r3], #4
    sub r3, r3, sp

    add sp, sp, #24
    bkpt #0
