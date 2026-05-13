/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFFFFFF"
  }
}
*/
.text
.arm
.global _start
_start:
    @ Test direct saturated add overflow
    @ R0 = 0x7FFFFFFE = INT_MAX - 1
    @ Use mvn to create 0x7FFFFFFE: mvn r0, #1 gives ~1 = 0xFFFFFFFE, but we need 0x7FFFFFFE
    @ Alternative: start from 0x7FFFFFFF and subtract 1
    mvn r0, #0x80000001   @ r0 = ~0x80000001 = 0x7FFFFFFE
    mov r1, #4
    qadd r0, r0, r1   @ 0x7FFFFFFE + 4 should saturate to 0x7FFFFFFF
    bkpt #0
