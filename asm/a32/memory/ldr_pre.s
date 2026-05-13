/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x12345678" }
}
*/
.text
.global _start
_start:
    @ LDR with pre-indexed addressing with writeback
    @ LDR R0, [R1, #4]! - R1 = R1 + 4, then load from R1
    
    sub sp, sp, #16
    
    @ Store data at sp+4
    ldr r2, =0x12345678
    str r2, [sp, #4]
    
    mov r1, sp
    ldr r0, [r1, #4]!   @ r1 = sp + 4, then load from r1
    
    add sp, sp, #16
    
    bkpt #0
.ltorg
