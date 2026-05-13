/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005"
  }
}
*/
// Test: Deep call chain (5 levels) with proper X30 preservation
// Each level adds to the counter
// RSB handles return addresses correctly

.text
.global _start
_start:
    mov x0, #0
    bl level1
    brk #0

level1:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    bl level2
    ldp x30, x19, [sp], #16
    ret

level2:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    bl level3
    ldp x30, x19, [sp], #16
    ret

level3:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    bl level4
    ldp x30, x19, [sp], #16
    ret

level4:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    bl level5
    ldp x30, x19, [sp], #16
    ret

level5:
    add x0, x0, #1
    ret
