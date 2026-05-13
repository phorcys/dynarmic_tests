/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x60000010",
    "R1": "0x80000010",
    "R2": "0x00000000",
    "R3": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    mov r2, #0
    subs r2, r2, #0
    mrs r0, cpsr          @ Z=1

    mov r3, #0
    subs r3, r3, #1
    mrs r1, cpsr          @ N=1

    mov r2, #0
    mov r3, #1
    bkpt #0
