/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// ADD self: 21 + 21 = 42

.text
.global _start
_start:
    mov x0, #21
    add x0, x0, x0
    brk #0
