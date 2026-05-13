/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000006",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: Function returns multiple values in registers
// No nested calls, so no RSB issue

.text
.global _start
_start:
    bl get_values
    brk #0

get_values:
    mov x0, #6
    mov x1, #1
    ret
