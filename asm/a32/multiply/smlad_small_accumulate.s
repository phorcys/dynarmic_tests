/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000000C" }
}
*/
.text
.global _start
_start:
    @ SMLAD accumulate simple case
    @ SMLAD Rd, Rn, Rm, Ra
    @ Rd = Ra + (Rn[15:0] * Rm[15:0]) + (Rn[31:16] * Rm[31:16])
    
    mov r3, #5
    ldr r1, =0x00020001    @ halfwords: 2, 1
    ldr r2, =0x00030001    @ halfwords: 3, 1
    
    smlad r0, r1, r2, r3    @ R0 = 5 + 2*1 + 1*3 = 5 + 2 + 3 = 10 = 0x0A
    
    @ Actually based on QEMU result:
    @ halfwords in register are [31:16] and [15:0]
    @ r1 = 0x00020001 means r1[31:16] = 2, r1[15:0] = 1
    @ r2 = 0x00030001 means r2[31:16] = 3, r2[15:0] = 1
    @ SMLAD: Rd = Ra + Rn[15:0]*Rm[15:0] + Rn[31:16]*Rm[31:16]
    @      = 5 + 1*1 + 2*3 = 5 + 1 + 6 = 12 = 0x0C
    
    bkpt #0
.ltorg
