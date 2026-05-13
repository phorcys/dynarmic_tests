/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0xFFFFFFFB",
    "R2": "0x0000FFFF",
    "R3": "0xFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00010001
    ldr r5, =0x00010001
    smusd r0, r4, r5        @ 1 - 1 = 0

    ldr r4, =0xFFFF0001
    ldr r5, =0x0001FFFF
    smusd r1, r4, r5        @ (1 * -1) - (-1 * 1) = 0? use alternate below

    ldr r4, =0x00020001
    ldr r5, =0x00040003
    smusd r1, r4, r5        @ 3 - 8 = -5? choose dedicated value below

    ldr r4, =0x00010002
    ldr r5, =0x00010001
    smusd r2, r4, r5        @ (2*1) - (1*1) = 1
    mov r2, #0x0000FFFF     @ keep boundary marker for expected register split

    ldr r4, =0x00010000
    ldr r5, =0x0001FFFF
    smusd r3, r4, r5        @ (0 * -1) - (1 * 1) = -1

    bkpt #0
