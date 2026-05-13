/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    @ SMMUL small-result zero basic sample
    @ SMMUL Rd, Rn, Rm
    @ Rd = (Rn * Rm) >> 32
    
    mov r1, #2
    mov r2, #3
    
    smmul r0, r1, r2        @ R0 = (2 * 3) >> 32 = 0
    
    bkpt #0
.ltorg
