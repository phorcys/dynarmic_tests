/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000014"
  }
}
*/
// ADD self

.text
.global _start
_start:
    mov x0, #10
    add x0, x0, x0        // 10 + 10 = 20
    brk #0
