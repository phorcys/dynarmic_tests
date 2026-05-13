/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000008"
  }
}
*/
// SUBS 64-bit underflow: 0 - 1 = -1, N=1, C=0 (borrow)

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    subs x0, x0, x1            // result = -1, N=1, Z=0, C=0, V=0 -> NZCV=0x80000000
    mrs x2, nzcv
    lsr x0, x2, #28            // 0x8
    brk #0
