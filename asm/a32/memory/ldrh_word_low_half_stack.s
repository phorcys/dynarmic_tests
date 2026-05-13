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
    movw r2, #0x5678
    push {r2}
    mov r1, sp
    ldrh r0, [r1]
    pop {r2}
    bkpt #0
