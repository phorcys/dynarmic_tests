/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000000000000",
    "X3": "0x0000000060000000",
    "X4": "0x0000000080000000",
    "X5": "0x0000000090000000",
    "X6": "0x0000000000000008",
    "X7": "0x0000000000000000"
  }
}
*/
// ADCS 32-bit coverage with carry-in, overflow, and overlap.

.text
.global _start
_start:
    mov w0, #0xFFFFFFFF
    cmp xzr, xzr
    adcs w2, w0, wzr
    mrs x3, nzcv

    mov w0, #1
    lsl w0, w0, #31
    sub w0, w0, #1            // 0x7FFFFFFF
    cmp xzr, xzr
    adcs w4, w0, wzr
    mrs x5, nzcv

    mov w6, #5
    mov w1, #3
    mov x0, #0
    cmp x0, #1
    adcs w6, w6, w1
    mrs x7, nzcv

    brk #0
