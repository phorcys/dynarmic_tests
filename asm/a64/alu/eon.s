/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF0F"
  }
}
*/
// Test: EON - Bitwise Exclusive OR NOT

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0x0F
    eon x0, x0, x1        // 0xFF ^ ~0x0F = 0xFF ^ 0xFFFF...F0 = 0xFFFF...0F

    brk #0
