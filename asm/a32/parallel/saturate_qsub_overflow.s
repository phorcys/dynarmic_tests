/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000000"
  }
}
*/
.text
.arm
.global _start
_start:
    @ Test QSUB with negative overflow
    @ R0 = INT_MIN, R1 = 1
    @ INT_MIN - 1 = 0x80000000 - 1 = 0x7FFFFFFF -> overflow to INT_MIN
    mvn r0, #0x7FFFFFFF   @ r0 = 0x80000000 (INT_MIN)
    mov r1, #1
    qsub r0, r0, r1   @ 0x80000000 - 1 should saturate to 0x80000000
    bkpt #0
