/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x00000001",
    "R2": "0xFFFFFFFF"
  }
}
*/
// Test: SUB - underflow and boundary cases

.text
.arm
.global _start
_start:
    @ 0 - 1 = -1 (underflow)
    mov r0, #0
    mov r1, #1
    sub r2, r0, r1          @ 0 - 1 = -1 = 0xFFFFFFFF

    bkpt #0
