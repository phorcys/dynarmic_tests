/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000064"
  }
}
*/
// CBNZ not taken

.text
.global _start
_start:
    mov x0, #0
    cbnz x0, taken
    mov x0, #100
    b end
    taken:
    mov x0, #1
    end:
    brk #0
