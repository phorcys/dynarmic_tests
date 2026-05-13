/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000001E"
  }
}
*/
// Chain same reg

.text
.global _start
_start:
    mov x0, #1
    add x0, x0, x0        // 2
    add x0, x0, x0        // 4
    add x0, x0, x0        // 8
    add x0, x0, x0        // 16
    add x0, x0, #14       // 30 = 0x1E
    brk #0
