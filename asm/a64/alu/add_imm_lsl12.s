/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0x0000000000001005",
    "X2": "0x0000000000000007",
    "X3": "0x0000000000002007"
  }
}
*/
// ADD immediate with optional LSL #12 for both 64-bit and 32-bit forms.

.text
.global _start
_start:
    mov x0, #5
    add x1, x0, #1, lsl #12     // 5 + 0x1000 = 0x1005

    mov w2, #7
    add w3, w2, #2, lsl #12     // 7 + 0x2000 = 0x2007

    brk #0
