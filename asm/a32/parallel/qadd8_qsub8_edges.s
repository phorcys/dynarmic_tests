/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7F817F80",
    "R1": "0x807E007E",
    "R2": "0x05050505",
    "R3": "0x03030303"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x7F807F80
    ldr r5, =0x01010180
    qadd8 r0, r4, r5        @ lane saturations both positive and negative

    ldr r4, =0x807F807F
    ldr r5, =0x01018001
    qsub8 r1, r4, r5

    ldr r4, =0x01020304
    ldr r5, =0x04030201
    qadd8 r2, r4, r5

    ldr r4, =0x05060708
    ldr r5, =0x02030405
    qsub8 r3, r4, r5

    bkpt #0
