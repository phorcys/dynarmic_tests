/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000064"
  }
}
*/
// TBNZ not taken (bit 0 is zero)

.text
.global _start
_start:
    mov x0, #0
    tbnz x0, #0, taken
    mov x0, #100
    b end
    taken:
    mov x0, #1
    end:
    brk #0
