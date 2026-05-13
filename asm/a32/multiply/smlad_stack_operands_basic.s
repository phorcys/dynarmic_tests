/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000008" }
}
*/
.text
.global _start
_start:
    @ SMLAD stack-loaded operands basic sample
    @ SMLAD Rd, Rn, Rm, Ra
    @ Rd = (Rn[15:0] * Rm[15:0]) + (Rn[31:16] * Rm[31:16]) + Ra
    
    @ Use memory to load values
    sub sp, sp, #16
    
    @ Store 0x00010002 at sp
    ldr r1, =0x00010002
    str r1, [sp]
    
    @ Store 0x00010002 at sp+4
    str r1, [sp, #4]
    
    ldr r1, [sp]         @ R1 = 0x00010002 (lo=2, hi=1)
    ldr r2, [sp, #4]     @ R2 = 0x00010002 (lo=2, hi=1)
    mov r3, #3           @ accumulator
    
    smlad r0, r1, r2, r3  @ R0 = (2*2) + (1*1) + 3 = 4 + 1 + 3 = 8
    
    add sp, sp, #16
    
    bkpt #0
.ltorg
