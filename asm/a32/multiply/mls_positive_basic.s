/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000002" }
}
*/
.text
.global _start
_start:
    @ MLS positive-result basic sample
    @ MLS Rd, Rn, Rm, Ra
    @ Rd = Ra - Rn * Rm
    
    mov r1, #3
    mov r2, #4
    mov r3, #14
    
    mls r0, r1, r2, r3   @ R0 = 14 - 3 * 4 = 2
    
    bkpt #0
