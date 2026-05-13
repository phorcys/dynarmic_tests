/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF8",
    "X1": "0xFFFFFFFFFFFFFFFC"
  }
}
*/
// Test: ASR Xd, Xn, #imm - Arithmetic Shift Right
// Shift right by immediate, preserving sign

.text
.global _start
_start:
    // ASR by immediate (negative number)
    mov x0, #-16        // 0xFFFFFFFFFFFFFFF0
    asr x0, x0, #1      // X0 = -16 >> 1 = -8 (arithmetic)
    
    mov x1, #-16
    asr x1, x1, #2      // X1 = -16 >> 2 = -4

    brk #0
