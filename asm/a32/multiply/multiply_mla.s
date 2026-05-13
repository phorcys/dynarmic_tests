/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000000D",
    "R1": "0x00000006",
    "R2": "0x00000004",
    "R3": "0x00000002"
  }
}
*/
.text
.global _start
_start:
    // MLA R0, R1, R2, R3  -> R0 = R1 * R2 + R3
    mov r1, #6
    mov r2, #4
    mov r3, #2
    mla r0, r1, r2, r3    // R0 = 6 * 4 + 2 = 26 = 0x1A
    
    mov r0, r0, LSR #1    // R0 = 26 >> 1 = 13 = 0x0D
    
    bkpt #0
