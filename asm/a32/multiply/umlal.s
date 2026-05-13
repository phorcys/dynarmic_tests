/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000004",
    "R1": "0x00000000",
    "R2": "0x00000002",
    "R3": "0x00000002"
  }
}
*/
.text
.global _start
_start:
    // UMLAL - Unsigned Multiply Accumulate Long
    // UMLAL RdLo, RdHi, Rn, Rm: RdHi:RdLo += Rn * Rm
    mov r2, #2
    mov r3, #2
    mov r0, #0        // RdLo
    mov r1, #0        // RdHi
    umlal r0, r1, r2, r3  // r1:r0 = 0 + 2*2 = 4
    
    bkpt #0
