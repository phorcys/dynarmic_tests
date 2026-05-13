/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000008",
    "X1": "0x0000000000000006"
  }
}
*/
// Test: Recursive Fibonacci
// fib(6) = 8

.text
.global _start
_start:
    mov x0, #6
    mov x1, #6
    bl fib
    mov x1, #6
    brk #0

fib:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    mov x19, x0
    cmp x19, #0
    b.eq fib_zero
    cmp x19, #1
    b.eq fib_one
    sub x0, x19, #1
    bl fib
    mov x20, x0
    sub x0, x19, #2
    bl fib
    add x0, x20, x0
    b fib_done
fib_zero:
    mov x0, #0
    b fib_done
fib_one:
    mov x0, #1
fib_done:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
