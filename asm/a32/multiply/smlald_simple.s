/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000004", "R1": "0x00000001" }
}
*/
.text
.global _start
_start:
    @ SMLALD: Signed Multiply Accumulate Long Dual
    @ SMLALD Rdlo, Rdhi, Rn, Rm
    @ Rdhi:Rdlo += Rn[15:0]*Rm[15:0] + Rn[31:16]*Rm[31:16]
    
    mov r0, #2             @ low accumulator
    mov r1, #1             @ high accumulator
    ldr r2, =0x00010001    @ halfwords: [31:16]=1, [15:0]=1
    ldr r3, =0x00010001    @ halfwords: [31:16]=1, [15:0]=1
    
    smlald r0, r1, r2, r3   @ r1:r0 = 0x100000002 + 1*1 + 1*1 = 0x100000004
                            @ r0 = 4, r1 = 1
    
    bkpt #0
.ltorg