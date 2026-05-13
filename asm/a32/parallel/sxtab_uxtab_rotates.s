/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000040",
    "R1": "0x0000011F",
    "R2": "0x0000000F",
    "R3": "0x00000020"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r4, =0x00000010
    ldr r5, =0x00003000
    sxtab r0, r4, r5, ror #8

    ldr r4, =0x00000020
    ldr r5, =0x0000FF00
    uxtab r1, r4, r5, ror #8

    ldr r4, =0x00000010
    ldr r5, =0x0000FF00
    sxtab r2, r4, r5, ror #8

    mov r4, #0
    ldr r5, =0x00200000
    uxtab r3, r4, r5, ror #16

    bkpt #0
