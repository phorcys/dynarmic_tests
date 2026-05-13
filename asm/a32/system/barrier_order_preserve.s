/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000002",
    "R2": "0x00000003",
    "R3": "0x00000004"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #1
    dmb sy
    mov r1, #2
    dsb sy
    mov r2, #3
    isb sy
    mov r3, #4
    bkpt #0
