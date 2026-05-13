/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    @ SMMUL zero-result basic sample
    @ SMMUL Rd, Rn, Rm
    @ Rd = (Rn * Rm) >> 32
    
    ldr r1, =0x00000001
    ldr r2, =0x10000000
    
    smmul r0, r1, r2        @ R0 = (1 * 0x10000000) >> 32 = 0
    
    bkpt #0
.ltorg
