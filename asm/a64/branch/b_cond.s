/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A",
    "X1": "0x0000000000000014",
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: B.cond - conditional branch

.text
.global _start
_start:
    mov x0, #10
    mov x1, #20
    cmp x0, x1
    b.lt less
    mov x2, #0               // not taken
    b done
less:
    mov x2, #1               // taken: x2 = 1
done:
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
