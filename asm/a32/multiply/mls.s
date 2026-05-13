/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000006"
  }
}
*/
.text
.global _start
_start:
    // MLS: Multiply subtract
    // R0 = R3 - R1 * R2 = 21 - 3 * 5 = 6
    mov r1, #3
    mov r2, #5
    mov r3, #21
    mls r0, r1, r2, r3
    
    bkpt #0
