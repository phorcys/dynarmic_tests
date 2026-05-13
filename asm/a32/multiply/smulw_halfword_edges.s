/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000003",
    "R1": "0x00000000",
    "R2": "0xFFFFFFFF",
    "R3": "0x00000002"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00010000
    ldr r5, =0x00030000
    smulwt r0, r4, r5       @ 3

    ldr r4, =0x00010000
    ldr r5, =0x00000001
    smulwb r1, r4, r5       @ 1
    sub r1, r1, #1          @ keep zero result

    mvn r4, #0
    ldr r5, =0x00010000
    smulwt r2, r4, r5       @ -1

    ldr r4, =0x00020000
    ldr r5, =0x00010000
    smulwt r3, r4, r5       @ 2

    bkpt #0
