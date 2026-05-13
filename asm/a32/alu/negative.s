/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFEB", "R1": "0x00000003", "R2": "0xFFFFFFF9" }
}
*/
.text
.global _start
_start:
    mvn r0, #20          // R0 = -21 (0xFFFFFFEB)
    mov r1, #3
    
    // R2 = -21 / 3 = -7 (0xFFFFFFF9)
    sdiv r2, r0, r1
    
    bkpt #0
