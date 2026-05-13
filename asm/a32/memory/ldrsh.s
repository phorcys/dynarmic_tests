/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xffff8766"
  }
}
*/
.text
.global _start
_start:
    @ LDRSH: Load signed halfword
    @ Store test data: 0x8766 (sign-extends to 0xFFFF8766)
    movw r2, #0x8766
    push {r2}
    
    @ Load signed halfword from stack
    mov r1, sp
    ldrsh r0, [r1]
    
    @ Restore stack
    pop {r2}
    bkpt #0
