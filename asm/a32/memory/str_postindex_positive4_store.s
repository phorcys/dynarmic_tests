/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xCAFEBABE",
    "R1": "0x00000004"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    mov r1, sp
    ldr r0, =0xCAFEBABE
    str r0, [r1], #4
    ldr r0, [sp]
    sub r1, r1, sp
    add sp, sp, #16
    bkpt #0
.ltorg
