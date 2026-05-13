/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005" }
}
*/
.text
.global _start
_start:
    @ SMLALD accumulate basic case
    @ SMLALD Rdlo, Rdhi, Rn, Rm
    @ Rdhi:Rdlo += (Rn[15:0] * Rm[15:0]) + (Rn[31:16] * Rm[31:16])
    
    mov r0, #0           @ Rdlo
    mov r1, #0           @ Rdhi
    
    ldr r2, =0x00030002  @ lo=2, hi=3
    ldr r3, =0x00010001  @ lo=1, hi=1
    
    smlald r0, r1, r2, r3  @ (2*1) + (3*1) = 2 + 3 = 5
    
    bkpt #0
.ltorg
