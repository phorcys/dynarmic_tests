/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000003" }
}
*/
.text
.global _start
_start:
    @ SMULWB: Signed Multiply (Word by halfword, Bottom half)
    @ SMULWB Rd, Rn, Rm
    @ Rd = (Rn * Rm[15:0]) >> 16
    
    mov r1, #1
    lsl r1, r1, #16      @ R1 = 0x10000 = 65536
    mov r2, #3           @ R2 bottom half = 3
    
    smulwb r0, r1, r2    @ R0 = (65536 * 3) >> 16 = 196608 >> 16 = 3
    
    bkpt #0
