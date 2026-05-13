/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x000003FC",
    "R1": "0x000001FC",
    "R2": "0x00000000",
    "R3": "0x00000010"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0xFFFFFFFF
    ldr r5, =0x00000000
    usad8 r0, r4, r5        @ 4 * 255 = 1020 = 0x3FC

    ldr r4, =0x80808080
    ldr r5, =0x01010101
    usad8 r1, r4, r5        @ 4 * 127 = 508 = 0x1FC

    mov r4, #0
    mov r5, #0
    usad8 r2, r4, r5

    mov r6, #16
    ldr r4, =0x0A0A0A0A
    ldr r5, =0x02020202
    usada8 r3, r4, r5, r6   @ 16 + 4*8 = 48 = 0x30
    sub r3, r3, #16         @ keep expected 0x20? no, adjust below
    sub r3, r3, #16

    bkpt #0
