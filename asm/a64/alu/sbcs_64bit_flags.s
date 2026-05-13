/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0xFFFFFFFFFFFFFFFF",
    "X3": "0x0000000080000000",
    "X4": "0xFFFFFFFFFFFFFFFF",
    "X5": "0x0000000080000000",
    "X6": "0x7FFFFFFFFFFFFFFF",
    "X7": "0x0000000030000000",
    "X8": "0x0000000000000002",
    "X9": "0x0000000020000000"
  }
}
*/
// SBCS 64-bit coverage with borrow, overflow, and overlap.

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    cmp xzr, xzr
    sbcs x2, x0, x1
    mrs x3, nzcv

    mov x0, #0
    mov x1, #0
    cmp x0, #1
    sbcs x4, x0, x1
    mrs x5, nzcv

    mov x0, #1
    lsl x0, x0, #63
    mov x1, #1
    cmp xzr, xzr
    sbcs x6, x0, x1
    mrs x7, nzcv

    mov x8, #5
    mov x1, #3
    cmp x0, #1                // x0 is minint, so C=1
    sbcs x8, x8, x1
    mrs x9, nzcv

    brk #0
