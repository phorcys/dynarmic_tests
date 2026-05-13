/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFF0000",
    "R1": "0x0000FFFF",
    "R2": "0x00070003",
    "R3": "0x00010009"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0xFFFF0000
    ldr r5, =0x0001FFFF
    uqasx r0, r4, r5

    ldr r4, =0x0000FFFF
    ldr r5, =0xFFFF0001
    uqsax r1, r4, r5

    ldr r4, =0x00050006
    ldr r5, =0x00030002
    uqasx r2, r4, r5

    ldr r4, =0x00050006
    ldr r5, =0x00030004
    uqsax r3, r4, r5

    bkpt #0
