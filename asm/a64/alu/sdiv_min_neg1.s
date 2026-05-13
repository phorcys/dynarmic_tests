/* CONFIG
{
  "RegData": {
    "X0": "0x8000000000000000"
  }
}
*/
// SDIV min/-1 overflow

.text
.global _start
_start:
    mov x0, #0x8000000000000000  // min signed int64
    movk x0, #0x8000, lsl #48
    mov x1, #-1
    sdiv x0, x0, x1       // min / -1 = min (overflow, result is min)
    brk #0
