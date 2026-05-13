/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0x8000
    movk x0, #0, lsl #16
    mul x0, x0, x0     // 0x8000 * 0x8000 = 0x40000000 (no overflow in 64-bit)
    cmp x0, #0x40000000
    cset x0, eq
    brk #0

