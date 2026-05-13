/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00005678" }
}
*/
.text
.global _start
_start:
    @ STRH with register offset
    @ STRH Rd, [Rn, Rm]
    
    sub sp, sp, #16
    
    ldr r0, =0x12345678
    mov r1, sp
    mov r2, #0
    strh r0, [r1, r2]    @ mem[sp] (halfword) = 0x5678
    
    ldrh r0, [sp]        @ R0 = 0x5678
    
    add sp, sp, #16
    bkpt #0
.ltorg
