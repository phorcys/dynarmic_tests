/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00005678" }
}
*/
.text
.global _start
_start:
    @ LDRH with register offset
    @ LDRH Rd, [Rn, Rm]
    
    sub sp, sp, #16
    ldr r2, =0x12345678
    str r2, [sp]
    
    mov r1, sp
    mov r2, #0
    ldrh r0, [r1, r2]    @ R0 = mem[sp] (halfword) = 0x5678
    
    add sp, sp, #16
    bkpt #0
.ltorg
