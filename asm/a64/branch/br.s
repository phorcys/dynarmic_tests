/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000002"
}
*/
// Test: BR Xn - Branch to Register
// Unconditional branch to address in register

.text
.global _start
_start:
    mov x0, #1
    adr x1, target
    br x1
    mov x0, #0  // should be skipped
target:
    mov x0, #2
    brk #0
