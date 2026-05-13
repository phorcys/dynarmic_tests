/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xDEADBEEF",
    "R2": "0xDEADBEEF"
  }
}
*/
.text
.global _start
_start:
    @ STR with pre-indexed writeback
    @ Use stack
    sub sp, sp, #8      @ allocate space
    mov r1, sp
    add r1, r1, #4      @ r1 = sp + 4
    
    ldr r0, =0xDEADBEEF
    str r0, [r1, #-4]!  @ r1 = r1-4 = sp, store R0 at sp
    
    @ Verify the value was stored
    ldr r2, [r1]        @ r2 = 0xDEADBEEF
    
    add sp, sp, #8      @ fix stack
    
    bkpt #0
.ltorg
