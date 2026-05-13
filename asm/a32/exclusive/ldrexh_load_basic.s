/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000abcd"
  }
}
*/
.text
.global _start
_start:
    @ LDREXH basic load-only sample
    movw r2, #0xabcd
    push {r2}
    
    mov r1, sp
    ldrexh r0, [r1]
    
    pop {r2}
    bkpt #0
