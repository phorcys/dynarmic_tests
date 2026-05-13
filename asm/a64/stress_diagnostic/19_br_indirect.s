/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/
// Test: Branch Register (BR) - direct jump to label
// Simplified: no adr, just use B instruction

.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    b func_a

func_a:
    add x0, x0, x1    // x0 = 3
    brk #0
