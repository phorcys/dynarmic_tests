/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0002FFFF",
    "R1": "0x00000001",
    "R2": "0x00040003",
    "R3": "0x00010005"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00010000
    ldr r5, =0x00010001
    uasx r0, r4, r5

    ldr r4, =0x00010000
    ldr r5, =0x00010001
    usax r1, r4, r5

    ldr r4, =0x00030004
    ldr r5, =0x00010001
    uasx r2, r4, r5

    ldr r4, =0x00030004
    ldr r5, =0x00010002
    usax r3, r4, r5

    bkpt #0
