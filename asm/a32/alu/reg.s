/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000032",
    "R1": "0x00000032"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r1, #50
    mov r0, r1
    bkpt #0
