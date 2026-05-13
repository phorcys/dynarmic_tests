/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x12345678" }
}
*/
.text
.global _start
_start:
    @ STR with register offset
    @ STR Rd, [Rn, Rm]
    
    sub sp, sp, #16
    
    ldr r0, =0x12345678
    mov r1, sp
    mov r2, #8
    str r0, [r1, r2]     @ mem[sp + 8] = 0x12345678
    
    ldr r0, [sp, #8]     @ R0 = 0x12345678
    
    add sp, sp, #16
    bkpt #0
.ltorg
