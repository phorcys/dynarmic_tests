/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000D",
    "X1": "0x0000000000000007"
  }
}
*/
// Test: Recursive Fibonacci
// fib(7) = 13 = 0xD

.text
.global _start
_start:
    mov x0, #7
    mov x1, #7
    bl fib
    mov x1, #7
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