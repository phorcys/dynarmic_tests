/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x12345678"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    ldr r0, =0x12345678
    str r0, [sp]
    ldr r1, [sp]
    add sp, sp, #8
    bkpt #0
