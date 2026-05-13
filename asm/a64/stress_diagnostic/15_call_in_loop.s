/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// Test: Single function call
// Simple add function

.text
.global _start
_start:
    mov x0, #0
    bl add_one
    brk #0

add_one:
    add x0, x0, #1
    ret
