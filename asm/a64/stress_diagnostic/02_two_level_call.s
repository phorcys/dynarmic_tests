/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000B",
    "X1": "0x0000000000000005"
  }
}
*/
// Test: Two-level nested function calls
// compute_b(1,2) = 1*2 + 2*3 = 8
// compute_a adds 8+1+2 = 11 = 0xB

.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    bl compute_a
    mov x1, #5
    brk #0

compute_b:
    stp x19, x20, [sp, #-16]!
    mov x19, x0
    mov x20, x1
    lsl x0, x19, #1
    mov x8, #3
    mul x1, x20, x8
    add x0, x0, x1
    ldp x19, x20, [sp], #16
    ret

compute_a:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    mov x19, x0
    mov x20, x1
    bl compute_b
    add x0, x0, x19
    add x0, x0, x20
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
