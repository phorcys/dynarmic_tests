/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00004E20", "R1": "0x00000000" }
}
*/
.text
.global _start
_start:
    @ UMULL small-value basic sample
    @ UMULL Rdlo, Rdhi, Rn, Rm
    @ Rdhi:Rdlo = Rn * Rm
    
    mov r2, #100
    mov r3, #200
    
    umull r0, r1, r2, r3 @ R1:R0 = 100 * 200 = 20000 = 0x4E20
                         @ R0 = 0x4E20, R1 = 0
    
    bkpt #0
