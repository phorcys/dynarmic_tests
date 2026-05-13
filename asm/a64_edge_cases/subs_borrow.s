/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x00000000FFFFFFFF",
    "X2": "0x0000000080000000"
  }
}
*/
// Edge case test: subs_borrow

.text
.global _start
_start:

    mov w0, #0
    subs w1, w0, #1   // 0 - 1 = 0xFFFFFFFF
    mrs x2, nzcv      // N=1, Z=0, C=0 (borrow), V=0 => NZCV=0x80000000


    brk #0
