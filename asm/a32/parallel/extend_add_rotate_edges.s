/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000011F",
    "R1": "0x0000000F",
    "R2": "0xFFFF8010",
    "R3": "0x00003010"
  }
}
*/
.text
.global _start
_start:
    mov r4, #0x20
    ldr r5, =0x0000FF00
    uxtab r0, r4, r5, ror #8

    mov r4, #0x10
    ldr r5, =0x0000FF00
    sxtab r1, r4, r5, ror #8

    mov r4, #0x10
    ldr r5, =0x80000000
    sxtah r2, r4, r5, ror #16

    mov r4, #0x10
    ldr r5, =0x30000000
    uxtah r3, r4, r5, ror #16

    bkpt #0
