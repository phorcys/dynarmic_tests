/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005"
  }
}
*/
// Test: Function with multiple return paths
// Tests conditional returns

.text
.global _start
_start:
    mov x0, #5
    bl abs_value
    brk #0

abs_value:
    cmp x0, #0
    bge abs_done
    neg x0, x0
abs_done:
    ret
