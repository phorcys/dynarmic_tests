/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000006",
    "X1": "0x0000000000000003"
  }
}
*/
// Test: Three-level nested function calls
// level3 adds 1, level2 adds 1, level1 adds 1 to input 3
// Result: 3 + 1 + 1 + 1 = 6

.text
.global _start
_start:
    mov x0, #3
    mov x1, #3
    bl level1
    mov x1, #3
    brk #0

level3:
    add x0, x0, #1
    ret

level2:
    stp x29, x30, [sp, #-16]!
    bl level3
    add x0, x0, #1
    ldp x29, x30, [sp], #16
    ret

level1:
    stp x29, x30, [sp, #-16]!
    bl level2
    add x0, x0, #1
    ldp x29, x30, [sp], #16
    ret