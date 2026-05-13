/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x01020304",
    "R1": "0x11223344",
    "R2": "0x55667788",
    "R3": "0x99AABBCC"
  }
}
*/
.text
.global _start
_start:
    ldr r0, =0x01020304
    ldr r1, =0x11223344
    ldr r2, =0x55667788
    ldr r3, =0x99AABBCC
    bkpt #0
.ltorg
