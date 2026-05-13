/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x00000103",
    "R2": "0x00010000",
    "R3": "0x03030303"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0xFFFF0000
    ldr r5, =0x0001FFFF
    uqadd16 r0, r4, r5

    ldr r4, =0x00020304
    ldr r5, =0x01030201
    uqsub8 r1, r4, r5

    ldr r4, =0x00010000
    ldr r5, =0x00000000
    uqadd16 r2, r4, r5

    ldr r4, =0x05060708
    ldr r5, =0x02030405
    uqsub8 r3, r4, r5

    bkpt #0
