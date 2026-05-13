/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000007E"
  }
}
*/
// Test: Function with 8 arguments
// 10+20+30+40+5+6+7+8 = 126 = 0x7E

.text
.global _start
_start:
    mov x0, #10
    mov x1, #20
    mov x2, #30
    mov x3, #40
    mov x4, #5
    mov x5, #6
    mov x6, #7
    mov x7, #8
    bl sum_8_args
    brk #0

sum_8_args:
    add x0, x0, x1
    add x0, x0, x2
    add x0, x0, x3
    add x0, x0, x4
    add x0, x0, x5
    add x0, x0, x6
    add x0, x0, x7
    ret