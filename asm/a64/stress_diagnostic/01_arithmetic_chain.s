/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002D"
  }
}
*/
// Test: Arithmetic chain
// ((5 + 3) * 2 - 4 + 8) / 2 + 10 = (16 - 4 + 8) / 2 + 10 = 20 / 2 + 10 = 10 + 10 = 20
// Actually: 5 + 3 = 8, *2 = 16, -4 = 12, +8 = 20, /2 = 10, +10 = 20, *2 = 40, -3 = 37, +8 = 45

.text
.global _start
_start:
    mov x0, #5
    add x0, x0, #3      // 8
    lsl x0, x0, #1      // 16 (*2)
    sub x0, x0, #4      // 12
    add x0, x0, #8      // 20
    lsr x0, x0, #1      // 10 (/2)
    add x0, x0, #10     // 20
    lsl x0, x0, #1      // 40 (*2)
    sub x0, x0, #3      // 37
    add x0, x0, #8      // 45 = 0x2D
    brk #0