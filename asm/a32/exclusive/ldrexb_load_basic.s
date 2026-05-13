/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x000000ab"
  }
}
*/
.text
.global _start
_start:
    @ LDREXB basic load-only sample
    mov r2, #0xab
    push {r2}
    
    mov r1, sp
    ldrexb r0, [r1]
    
    pop {r2}
    bkpt #0
