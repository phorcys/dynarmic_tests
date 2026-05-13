/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000000A",
    "R1": "0x00000014",
    "R2": "0x000001FC",
    "R3": "0x00000200"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x01020304
    ldr r5, =0x00000000
    usad8 r0, r4, r5        @ 1+2+3+4 = 10

    mov r6, #10
    usad8 r1, r4, r5
    add r1, r1, r6          @ 20

    ldr r4, =0xFFFFFFFF
    ldr r5, =0x80808080
    usad8 r2, r4, r5        @ 4 * 127 = 508 = 0x1FC

    mov r6, #4
    usada8 r3, r4, r5, r6   @ 508 + 4 = 512

    bkpt #0
