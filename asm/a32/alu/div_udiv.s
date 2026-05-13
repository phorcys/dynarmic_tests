/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000002"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r1, #10
    mov r2, #5
    udiv r0, r1, r2
    bkpt #0
