/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/
// Test: RET instruction (return using X30)
// Simple call chain

.text
.global _start
_start:
    mov x0, #1
    bl first_call
    brk #0

first_call:
    add x0, x0, #2    // x0 = 3
    ret
