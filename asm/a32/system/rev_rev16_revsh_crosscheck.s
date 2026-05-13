/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xDDCCBBAA",
    "R1": "0xBBAADDCC",
    "R2": "0xFFFFAABB",
    "R3": "0x00002211"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0xAABBCCDD
    rev r0, r4

    ldr r4, =0xAABBCCDD
    rev16 r1, r4

    ldr r4, =0x0000BBAA
    revsh r2, r4

    ldr r4, =0x00001122
    revsh r3, r4

    bkpt #0
