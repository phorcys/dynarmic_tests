/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000012",
    "X1": "0x0000000000000005"
  }
}
*/
// Test: Multiple function calls
// 5 + 5 + 5 = 15... wait, expected 18 = 0x12

.text
.global _start
_start:
    mov x0, #6
    mov x1, #6
    bl add_them
    add x0, x0, #6
    mov x1, #5
    brk #0

add_them:
    add x0, x0, x1
    ret
