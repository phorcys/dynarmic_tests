/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000008",
    "X1": "0x0000000000000005"
  }
}
*/
// Test: Function call with callee-saved registers

.text
.global _start
_start:
    mov x0, #3
    mov x1, #5
    bl add_with_save
    brk #0

add_with_save:
    stp x19, x20, [sp, #-16]!
    add x0, x0, x1
    ldp x19, x20, [sp], #16
    ret
