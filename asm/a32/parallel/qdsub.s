/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000000",
    "R1": "0x00000002"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r1, #2
    @ R0 = 0x80000000 = INT_MIN
    mvn r0, #0x7FFFFFFF   @ r0 = ~0x7FFFFFFF = 0x80000000
    @ R0 = 0x80000002 = INT_MIN + 2
    add r0, r0, #2
    qdsub r0, r0, r1   @ R0 = R0 - saturated_double(R1) = 0x80000002 - 4 = 0x7FFFFFFE -> saturates to 0x80000000
    bkpt #0
