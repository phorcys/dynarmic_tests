/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x00000000",
    "R2": "0x00040006",
    "R3": "0x00020002"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0xFFFF0000
    ldr r5, =0x0001FFFF
    uqadd16 r0, r4, r5

    ldr r4, =0x00000000
    ldr r5, =0x00010001
    uqsub16 r1, r4, r5

    ldr r4, =0x00010002
    ldr r5, =0x00030004
    uqadd16 r2, r4, r5

    ldr r4, =0x00050006
    ldr r5, =0x00030004
    uqsub16 r3, r4, r5

    bkpt #0
