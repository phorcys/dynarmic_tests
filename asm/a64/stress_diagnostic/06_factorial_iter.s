/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000002D0"
  }
}
*/
// Test: Iterative factorial
// 6! = 720 = 0x2D0

.text
.global _start
_start:
    mov x0, #1        // result
    mov x1, #6        // n
loop:
    cmp x1, #1
    b.le done
    mul x0, x0, x1
    sub x1, x1, #1
    b loop
done:
    // x0 = 720 = 0x2D0
    brk #0