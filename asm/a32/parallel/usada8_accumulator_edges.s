/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000014",
    "R1": "0x00000010",
    "R2": "0x00000000",
    "R3": "0x0000040C"
  }
}
*/
.text
.global _start
_start:
    mov r6, #10
    ldr r4, =0x01020304
    ldr r5, =0x00000000
    usada8 r0, r4, r5, r6   @ 10 + 10 = 20

    mov r6, #16
    ldr r4, =0x00000000
    ldr r5, =0x00000000
    usada8 r1, r4, r5, r6   @ 16

    mov r6, #0
    ldr r4, =0x00000000
    ldr r5, =0x00000000
    usada8 r2, r4, r5, r6   @ 0

    mov r6, #0x10
    ldr r4, =0xFFFFFFFF
    ldr r5, =0x00000000
    usada8 r3, r4, r5, r6   @ 0x10 + 4*255 = 0x110

    bkpt #0
