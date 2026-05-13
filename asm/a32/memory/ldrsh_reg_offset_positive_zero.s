/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00005678" }
}
*/
.text
.global _start
_start:
    @ LDRSH with register offset
    @ LDRSH Rd, [Rn, Rm]
    
    sub sp, sp, #16
    ldr r2, =0x12345678
    str r2, [sp]
    
    mov r1, sp
    mov r2, #0
    ldrsh r0, [r1, r2]   @ R0 = sign_extend(mem[sp] halfword) = sign_extend(0x5678) = 0x5678
    
    add sp, sp, #16
    bkpt #0
.ltorg
