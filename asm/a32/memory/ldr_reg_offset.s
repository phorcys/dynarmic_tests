/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x12345678", "R1": "0x00001000" }
}
*/
.text
.global _start
_start:
    @ LDR with register offset
    @ LDR Rd, [Rn, Rm]
    
    sub sp, sp, #16
    ldr r2, =0x12345678
    str r2, [sp, #8]
    
    mov r1, sp
    mov r2, #8
    ldr r0, [r1, r2]     @ R0 = mem[sp + 8] = 0x12345678
    add r1, r1, r2       @ R1 = sp + 8 (not used for expected)
    
    mov r1, #0x1000
    
    add sp, sp, #16
    bkpt #0
.ltorg
