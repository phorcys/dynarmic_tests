/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000003",
  "X30": "0x0000000000000003"
}
*/
// Test: BL label - Branch with Link
// Branches and stores return address in X30

.text
.global _start
_start:
    mov x0, #1
    bl func
    add x0, x0, #1  // x0 = 3
    brk #0

func:
    add x0, x0, #1  // x0 = 2
    ret
