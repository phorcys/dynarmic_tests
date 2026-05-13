/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// CBNZ taken

.text
.global _start
_start:
    mov x0, #1
    cbnz x0, taken
    mov x0, #100
    b end
    taken:
    mov x0, #1
    end:
    brk #0
