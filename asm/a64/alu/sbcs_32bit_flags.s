/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x00000000FFFFFFFF",
    "X3": "0x0000000080000000",
    "X4": "0x00000000FFFFFFFF",
    "X5": "0x0000000080000000",
    "X6": "0x000000007FFFFFFF",
    "X7": "0x0000000030000000",
    "X8": "0x0000000000000002",
    "X9": "0x0000000020000000"
  }
}
*/
// SBCS 32-bit coverage with borrow, overflow, and overlap.

.text
.global _start
_start:
    mov w0, #0
    mov w1, #1
    cmp xzr, xzr
    sbcs w2, w0, w1
    mrs x3, nzcv

    mov w0, #0
    mov w1, #0
    mov x10, #0
    cmp x10, #1
    sbcs w4, w0, w1
    mrs x5, nzcv

    mov w0, #1
    lsl w0, w0, #31
    mov w1, #1
    cmp xzr, xzr
    sbcs w6, w0, w1
    mrs x7, nzcv

    mov w8, #5
    mov w1, #3
    cmp xzr, xzr
    sbcs w8, w8, w1
    mrs x9, nzcv

    brk #0
