/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000014" }
}
*/
.text
.global _start
_start:
    @ SMLSLD accumulate basic case
    @ SMLSLD Rdlo, Rdhi, Rn, Rm
    @ Rdhi:Rdlo += (Rn[15:0] * Rm[15:0]) - (Rn[31:16] * Rm[31:16])
    
    mov r0, #20          @ Rdlo = 20
    mov r1, #0           @ Rdhi = 0
    
    ldr r2, =0x00020003  @ lo=3, hi=2
    ldr r3, =0x00010002  @ lo=2, hi=1
    
    smlsld r0, r1, r2, r3  @ 20 + (3*2) - (2*1) = 20 + 6 - 2 = 24
    
    @ Simpler test
    mov r0, #10
    mov r1, #0
    
    ldr r2, =0x00010002  @ lo=2, hi=1
    ldr r3, =0x00010003  @ lo=3, hi=1
    
    smlsld r0, r1, r2, r3  @ 10 + (2*3) - (1*1) = 10 + 6 - 1 = 15
    
    @ Even simpler
    mov r0, #0
    mov r1, #0
    
    ldr r2, =0x00030002  @ lo=2, hi=3
    ldr r3, =0x00020001  @ lo=1, hi=2
    
    smlsld r0, r1, r2, r3  @ (2*1) - (3*2) = 2 - 6 = -4
    
    @ Let me use positive result
    mov r0, #20
    mov r1, #0
    
    ldr r2, =0x00010002  @ lo=2, hi=1
    ldr r3, =0x00020001  @ lo=1, hi=2
    
    smlsld r0, r1, r2, r3  @ 20 + (2*1) - (1*2) = 20 + 2 - 2 = 20
    
    bkpt #0
.ltorg
