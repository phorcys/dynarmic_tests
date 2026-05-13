/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000037",
    "X1": "0x000000000000000A"
  }
}
*/
// Test: Iterative Fibonacci fib(10) = 55 = 0x37

.text
.global _start
_start:
    mov x0, #10
    mov x1, #10
    bl fib_iter
    mov x1, #10
    brk #0

fib_iter:
    mov x2, #0
    mov x3, #1
    mov x4, #0
loop:
    cmp x4, x0
    b.ge done
    add x5, x2, x3
    mov x2, x3
    mov x3, x5
    add x4, x4, #1
    b loop
done:
    mov x0, x2
    ret
