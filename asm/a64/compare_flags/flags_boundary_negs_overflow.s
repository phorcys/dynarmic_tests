/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000008"
  }
}
*/
// NEGS: 0 - max_positive = large negative, N=1, no overflow

.text
.global _start
_start:
    mov x0, #0x7FFFFFFFFFFFFFFF  // max positive
    negs x0, x0                  // 0 - max_pos -> N=1, Z=0, C=0, V=0 -> NZCV=0x80000000
    mrs x1, nzcv
    lsr x0, x1, #28              // 0x8
    brk #0
