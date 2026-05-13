/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R4": "0x00001234"
  }
}
*/
.text
.global _start
_start:
    @ POP: Pop from stack
    ldr r0, =0x00001234
    push {r0}
    
    pop {r4}
    bkpt #0
