/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000018"
  }
}
*/
.text
.global _start
_start:
    // MLA: Multiply accumulate
    // R0 = R1 * R2 + R3 = 3 * 5 + 9 = 24 = 0x18
    mov r1, #3
    mov r2, #5
    mov r3, #9
    mla r0, r1, r2, r3
    
    bkpt #0
