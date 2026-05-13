/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// SDIV by zero

.text
.global _start
_start:
    mov x0, #100
    mov x1, #0
    sdiv x0, x0, x1       // 100 / 0 = 0 (architecturally defined)
    brk #0
