/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000080000000"
  }
}
*/
// Edge case test: sdiv_intmin

.text
.global _start
_start:

    mov w0, #1
    lsl w0, w0, #31   // w0 = 0x80000000 (INT_MIN)
    mov w1, #0xFFFF
    movk w1, #0xFFFF, lsl #16   // w1 = -1
    sdiv w2, w0, w1   // INT_MIN / -1 = INT_MIN (overflow, returns INT_MIN)


    brk #0
