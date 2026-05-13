/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000018" }
}
*/
.text
.global _start
_start:
    @ MLA positive accumulate sample
    @ MLA Rd, Rn, Rm, Ra
    @ Rd = Ra + Rn * Rm
    
    mov r1, #7         @ R1 = 7
    mov r2, #2         @ R2 = 2
    mov r3, #10        @ R3 = 10
    
    mla r0, r1, r2, r3   @ R0 = 10 + 7 * 2 = 24
    
    bkpt #0
