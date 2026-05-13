/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000F",
    "X1": "0x0000000000000005"
  }
}
*/
// Test: Simple stack operations

.text
.global _start
_start:
    mov x0, #10
    mov x1, #5
    add x0, x0, x1
    brk #0
