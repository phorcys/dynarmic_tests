/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x00000000",
    "R2": "0x05050505",
    "R3": "0x03030303"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0xFFFFFFFF
    ldr r5, =0x01010101
    uqadd8 r0, r4, r5

    ldr r4, =0x00000000
    ldr r5, =0x01010101
    uqsub8 r1, r4, r5

    ldr r4, =0x01020304
    ldr r5, =0x04030201
    uqadd8 r2, r4, r5

    ldr r4, =0x05060708
    ldr r5, =0x02030405
    uqsub8 r3, r4, r5

    bkpt #0
