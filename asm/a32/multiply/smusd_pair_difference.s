/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFFC" }
}
*/
.text
.global _start
_start:
    @ SMUSD pairwise basic sample
    @ SMUSD Rd, Rn, Rm
    @ Rd = (Rn[15:0] * Rm[15:0]) - (Rn[31:16] * Rm[31:16])
    
    ldr r1, =0x00030002    @ halfwords: [31:16]=3, [15:0]=2
    ldr r2, =0x00020001    @ halfwords: [31:16]=2, [15:0]=1
    
    smusd r0, r1, r2        @ R0 = 2*1 - 3*2 = 2 - 6 = -4 = 0xFFFFFFFC
    
    bkpt #0
.ltorg
