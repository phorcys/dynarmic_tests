/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00005678"
  }
}
*/
.text
.global _start
_start:
    movw r0, #0x5678
    sub sp, sp, #4
    mov r1, sp
    strh r0, [r1]
    ldrh r0, [r1]
    add sp, sp, #4
    bkpt #0
