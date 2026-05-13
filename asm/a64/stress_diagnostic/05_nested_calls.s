/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000037",
    "X1": "0x0000000000000005"
  }
}
*/
// Test: Nested calls - sum of squares 1-5
// 1+4+9+16+25 = 55 = 0x37

.text
.global _start
_start:
    mov x0, #5
    mov x1, #5
    bl sum_squares
    mov x1, #5
    brk #0

sum_squares:
    mov x1, #0
    mov x2, #1
loop:
    cmp x2, x0
    b.gt done
    mul x3, x2, x2
    add x1, x1, x3
    add x2, x2, #1
    b loop
done:
    mov x0, x1
    ret
