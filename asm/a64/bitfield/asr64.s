/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF",
    "X1": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: ASR - Arithmetic Shift Right (64-bit)

.text
.global _start
_start:
    // -1 >> 63 = -1 (sign extension)
    mov x0, #-1
    asr x0, x0, #63
    
    // -2 >> 1 = -1 (arithmetic shift preserves sign)
    mov x1, #-2
    asr x1, x1, #1

    brk #0
