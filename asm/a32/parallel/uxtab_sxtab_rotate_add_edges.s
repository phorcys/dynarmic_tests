/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000023",
    "R1": "0x00000004",
    "R2": "0x00007FFF",
    "R3": "0x0000007F"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00112233
    mov r5, #1
    uxtab r0, r5, r4, ror #8

    ldr r4, =0x80FF0000
    mov r5, #4
    sxtab r1, r5, r4, ror #8

    ldr r4, =0x7FFF0000
    mov r5, #0
    uxtah r2, r5, r4, ror #16

    ldr r4, =0x007F0000
    mov r5, #0
    sxtah r3, r5, r4, ror #16

    bkpt #0
