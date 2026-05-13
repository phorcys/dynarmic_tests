/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xffffff88"
  }
}
*/
.text
.global _start
_start:
    @ LDRSB: Load signed byte
    @ Store test data on stack: 0x88 (sign-extends to 0xFFFFFF88)
    mov r2, #0x88
    push {r2}
    
    @ Load signed byte from stack
    mov r1, sp
    ldrsb r0, [r1]
    
    @ Restore stack
    pop {r2}
    bkpt #0
