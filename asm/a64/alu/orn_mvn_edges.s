/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x000000007FFFFFFE",
    "X3": "0xFFFFFFFFFFFFFFFE",
    "X4": "0xFFFFFFFFFFFFFFF0",
    "X5": "0x00000000FFFFFFF0"
  }
}
*/
// ORN/MVN edge coverage across 64-bit and 32-bit forms.

.text
.global _start
_start:
    mov w0, #0
    mov w1, #1
    lsl w1, w1, #31
    add w1, w1, #1
    orn w2, w0, w1             // ~0x80000001

    mov x3, #1
    mvn x3, x3                 // ~1

    mov x4, #0x0F
    orn x4, xzr, x4            // ~0x0F

    mov w5, #0x0F
    mvn w5, w5                 // 32-bit ~0x0F

    brk #0
