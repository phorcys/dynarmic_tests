/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A"
  }
}
*/
// Test: Nested logic with conditionals (converted to arithmetic)
// Simulate: if (x > 5) x += 2; else x += 1;
// x = 7, so x > 5, x = 7 + 2 = 9
// Then: x * 2 - 8 = 18 - 8 = 10

.text
.global _start
_start:
    mov x0, #7
    // Simulate conditional: if (x > 5) x += 2 else x += 1
    // Using arithmetic: (x > 5) ? 2 : 1
    cmp x0, #5
    csel x1, x0, x0, gt    // x1 = x0 (for gt)
    mov x2, #2
    mov x3, #1
    csel x4, x2, x3, gt    // x4 = 2 if gt, else 1
    add x0, x0, x4         // x0 = 7 + 2 = 9
    // Continue: x * 2 - 8 = 18 - 8 = 10
    lsl x0, x0, #1         // 18
    sub x0, x0, #8         // 10
    brk #0
