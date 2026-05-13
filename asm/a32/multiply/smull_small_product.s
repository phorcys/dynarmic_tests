/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x000000C8", "R1": "0x00000000" }
}
*/
.text
.global _start
_start:
    @ SMULL: Signed Multiply Long
    
    mov r2, #10
    mov r3, #20
    
    smull r0, r1, r2, r3 @ R1:R0 = 10 * 20 = 200 = 0xC8
                         @ R0 = 0xC8, R1 = 0
    
    bkpt #0