/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000039"
  }
}
*/
// Test: Loop sum
// Sum from 1 to 10 = 55
// Then add 2: 55 + 2 = 57 = 0x39

.text
.global _start
_start:
    mov x0, #0        // sum
    mov x1, #1        // counter
loop:
    cmp x1, #10
    b.gt done
    add x0, x0, x1
    add x1, x1, #1
    b loop
done:
    // x0 = 55
    add x0, x0, #2    // 57 = 0x39
    brk #0