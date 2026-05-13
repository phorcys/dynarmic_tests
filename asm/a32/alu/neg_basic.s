/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFFE" }
}
*/
.text
.global _start
_start:
    @ NEG: Negate (alias for RSB Rd, Rn, #0)
    mov r1, #2
    
    neg r0, r1         @ R0 = 0 - 2 = -2 = 0xFFFFFFFE
    
    bkpt #0
