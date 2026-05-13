/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000015", "R1": "0x00000003", "R2": "0x00000007" }
}
*/
.text
.global _start
_start:
    mov r0, #21
    mov r1, #3
    
    // R2 = R0 / R1 = 21 / 3 = 7
    sdiv r2, r0, r1
    
    bkpt #0