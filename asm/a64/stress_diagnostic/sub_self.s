/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// SUB self

.text
.global _start
_start:
    mov x0, #10
    sub x0, x0, x0        // 10 - 10 = 0
    brk #0
