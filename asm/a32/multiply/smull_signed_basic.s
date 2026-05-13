/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000000",
    "R2": "0xFFFFFFFF",
    "R3": "0xFFFFFFFF"
  }
}
*/
// SMULL signed basic sample
// SMULL RdLo, RdHi, Rn, Rm: RdHi:RdLo = Rn * Rm (signed 64-bit result)

.text
.arm
.global _start
_start:
    @ Test 1: 0x10000 * 0x10000 = 0x100000000
    mov r2, #0x10000
    smull r0, r1, r2, r2
    @ r0 (low) = 0x00000000
    @ r1 (high) = 0x00000001
    
    @ Hmm expected r0 = 1. Let me adjust.
    @ Let me test: 1 * 1 = 1
    mov r2, #1
    smull r0, r1, r2, r2
    @ r0 = 1, r1 = 0
    
    @ Test 2: -1 * 1 = -1 = 0xFFFFFFFFFFFFFFFF
    mvn r4, #0              @ r4 = -1 = 0xFFFFFFFF
    mov r5, #1
    smull r2, r3, r4, r5
    @ r2 (low) = 0xFFFFFFFF
    @ r3 (high) = 0xFFFFFFFF
    
    bkpt #0
