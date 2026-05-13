/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x99AABBCC",
    "R1": "0x11112222",
    "R2": "0x55227744",
    "R3": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    ldr r1, =0x11223344
    ldr r2, =0x99AABBCC

    msr cpsr_f, #0
    sel r0, r1, r2          @ GE=0000 -> all bytes from Rm

    ldr r1, =0x11112222
    ldr r2, =0x55556666
    ldr r4, =0xFFFFFFFF
    ldr r5, =0x01010101
    uadd8 r6, r4, r5        @ GE=1111
    sel r1, r1, r2          @ all bytes from Rn

    ldr r2, =0x55667788
    ldr r3, =0x11223344
    ldr r4, =0xFF00FF00
    ldr r5, =0x01000100
    uadd8 r6, r4, r5        @ alternating carry lanes
    sel r2, r2, r3

    mov r3, #0

    bkpt #0
