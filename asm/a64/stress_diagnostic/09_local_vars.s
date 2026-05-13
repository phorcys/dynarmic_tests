/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000037",
    "X1": "0x000000000000000A"
  }
}
*/
// Test: Sum 1-10 = 55 = 0x37

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
loop:
    cmp x1, #11
    b.eq done
    add x0, x0, x1
    add x1, x1, #1
    b loop
done:
    mov x1, #10
    brk #0