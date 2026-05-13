/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000005",
    "R1": "0x0000000A",
    "R2": "0x00000005"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r1, #10
    mov r2, #5
    sub r0, r1, r2
    bkpt #0
