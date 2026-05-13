/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000016" }
}
*/
.text
.global _start
_start:
    @ SMLAD positive pair basic sample
    @ SMLAD Rd, Rn, Rm, Ra
    @ Rd = Ra + (Rn[15:0] * Rm[15:0] + Rn[31:16] * Rm[31:16])
    
    ldr r1, =0x00020003     @ halfwords: [2, 3]
    ldr r2, =0x00050004     @ halfwords: [5, 4]
    mov r3, #0              @ accumulator = 0
    
    smlad r0, r1, r2, r3    @ R0 = 0 + (3*4 + 2*5) = 0 + 12 + 10 = 22 = 0x16
    
    bkpt #0
.ltorg
