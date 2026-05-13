/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFF8000",
    "R1": "0x00007FFF",
    "R2": "0x00070003",
    "R3": "0x00010009"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x7FFF8000
    ldr r5, =0x00018000
    qasx r0, r4, r5

    ldr r4, =0x80007FFF
    ldr r5, =0x00018000
    qsax r1, r4, r5

    ldr r4, =0x00050006
    ldr r5, =0x00030002
    qasx r2, r4, r5

    ldr r4, =0x00050006
    ldr r5, =0x00030004
    qsax r3, r4, r5

    bkpt #0
