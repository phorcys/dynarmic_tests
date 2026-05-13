/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFE",
    "R1": "0x40007FFF",
    "R2": "0xFFFFFFFF",
    "R3": "0x00008000"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0xFFFF0001
    ldr r5, =0x0001FFFF
    smuad r0, r4, r5        @ (1 * -1) + (-1 * 1) = -2

    ldr r4, =0x7FFF8000
    ldr r5, =0x00018000
    smuad r1, r4, r5        @ (-32768 * -32768) + (32767 * 1) = 0x40007FFF

    ldr r4, =0x7FFF8000
    ldr r5, =0x00010001
    smuad r2, r4, r5        @ (-32768 * 1) + (32767 * 1) = -1

    ldr r4, =0x40004000
    ldr r5, =0x00010001
    smuad r3, r4, r5        @ 0x4000 + 0x4000 = 0x8000

    bkpt #0
