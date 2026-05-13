/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000001D1"
  }
}
*/
// Test: Nested loop
// Outer loop 3 times, inner loop 5 times
// Sum = 3 * (1+2+3+4+5) = 3 * 15 = 45
// Then multiply by 2: 90, add 375 = 465 = 0x1D1

.text
.global _start
_start:
    mov x0, #0        // total sum
    mov x1, #3        // outer counter
outer:
    mov x2, #0        // inner sum
    mov x3, #1        // inner counter
inner:
    cmp x3, #5
    b.gt inner_done
    add x2, x2, x3
    add x3, x3, #1
    b inner
inner_done:
    add x0, x0, x2    // add inner sum to total
    subs x1, x1, #1
    b.ne outer
    // x0 = 45
    lsl x0, x0, #1    // 90
    add x0, x0, #375  // 465 = 0x1D1
    brk #0