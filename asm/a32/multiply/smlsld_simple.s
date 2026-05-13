/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000002", "R1": "0x00000001" }
}
*/
.text
.global _start
_start:
    @ SMLSLD: Signed Multiply Subtract Long Dual
    @ SMLSLD Rdlo, Rdhi, Rn, Rm
    @ Rdhi:Rdlo += Rn[15:0]*Rm[15:0] - Rn[31:16]*Rm[31:16]
    
    mov r0, #2             @ low accumulator
    mov r1, #1             @ high accumulator
    ldr r2, =0x00010002    @ halfwords: 1, 2
    ldr r3, =0x00020001    @ halfwords: 2, 1
    
    smlsld r0, r1, r2, r3   @ r1:r0 = 0x100000002 + 2*1 - 1*2 = 0x100000002
                            @ r0 = 2, r1 = 1
    
    bkpt #0
.ltorg
