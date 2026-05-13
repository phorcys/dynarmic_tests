/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000000000000",
    "X3": "0x0000000060000000",
    "X4": "0x8000000000000000",
    "X5": "0x0000000090000000",
    "X6": "0x0000000000000008",
    "X7": "0x0000000000000000"
  }
}
*/
// ADCS 64-bit coverage with carry-in, overflow, and overlap.

.text
.global _start
_start:
    movn x0, #0
    cmp xzr, xzr
    adcs x2, x0, xzr
    mrs x3, nzcv

    mov x0, #1
    lsl x0, x0, #63
    sub x0, x0, #1            // 0x7FFFFFFFFFFFFFFF
    cmp xzr, xzr
    adcs x4, x0, xzr
    mrs x5, nzcv

    mov x6, #5
    mov x1, #3
    mov x0, #0
    cmp x0, #1
    adcs x6, x6, x1
    mrs x7, nzcv

    brk #0
