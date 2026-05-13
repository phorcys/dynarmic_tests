/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x12345678" }
}
*/
.text
.global _start
_start:
    @ LDR with post-indexed addressing
    @ LDR R0, [R1], #4 - Load from R1, then R1 = R1 + 4
    
    @ Set up data on stack
    sub sp, sp, #16
    ldr r2, =0x12345678
    str r2, [sp]
    
    mov r1, sp
    ldr r0, [r1], #4   @ Load from sp, r1 = sp + 4
    
    add sp, sp, #16
    
    bkpt #0
.ltorg
