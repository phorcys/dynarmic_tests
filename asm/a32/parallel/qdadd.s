/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFFFFFF",
    "R1": "0x00000002"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r1, #2
    mov r0, #0x7FFFFFF0
    add r0, r0, #14     @ R0 = 0x7FFFFFFE
    qdadd r0, r0, r1    @ R0 = saturated_double(R1) + R0 = 4 + 0x7FFFFFFE = 0x80000002 -> saturates to 0x7FFFFFFF
    bkpt #0
