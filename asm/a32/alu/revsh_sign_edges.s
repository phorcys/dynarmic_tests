/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFF80FF",
    "R1": "0x00007F80",
    "R2": "0xFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    ldr r3, =0x0000FF80
    revsh r0, r3

    ldr r3, =0x0000807F
    revsh r1, r3

    mvn r2, #0
    revsh r2, r2

    bkpt #0
