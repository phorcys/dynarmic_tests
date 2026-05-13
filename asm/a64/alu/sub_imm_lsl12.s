/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000005000",
    "X1": "0x0000000000004000",
    "X2": "0x0000000000003000",
    "X3": "0x0000000000001000"
  }
}
*/
// SUB immediate with optional LSL #12 for both 64-bit and 32-bit forms.

.text
.global _start
_start:
    mov x0, #5
    lsl x0, x0, #12             // x0 = 0x5000
    sub x1, x0, #1, lsl #12     // 0x5000 - 0x1000 = 0x4000

    mov w2, #3
    lsl w2, w2, #12             // w2 = 0x3000
    sub w3, w2, #2, lsl #12     // 0x3000 - 0x2000 = 0x1000

    brk #0
