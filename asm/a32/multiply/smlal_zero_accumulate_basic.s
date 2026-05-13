/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000006", "R1": "0x00000000" }
}
*/
.text
.global _start
_start:
    @ SMLAL zero-accumulate basic sample
    @ SMLAL Rdlo, Rdhi, Rn, Rm
    @ Rdhi:Rdlo += Rn * Rm
    
    mov r0, #0              @ Rdlo = 0
    mov r1, #0              @ Rdhi = 0
    mov r2, #2              @ Rn = 2
    mov r3, #3              @ Rm = 3
    
    smlal r0, r1, r2, r3    @ R1:R0 = 0 + 2 * 3 = 6
                            @ r0 = 6 (low), r1 = 0 (high)
    
    bkpt #0
.ltorg
