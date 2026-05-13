/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000000F",
    "R1": "0x0000000A"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #5
    mov r1, #10
    isb
    add r0, r0, r1
    bkpt #0
