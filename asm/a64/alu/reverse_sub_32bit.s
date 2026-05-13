/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x00000000FFFFFFFB",
    "X3": "0x0000000080000000",
    "X4": "0x00000000FFFFFFFF",
    "X6": "0x00000000FFFFF001"
  }
}
*/
// Reverse-sub semantics encoded via SUB from WZR or zero-valued source.

.text
.global _start
_start:
    mov w0, #5
    sub w1, wzr, w0

    mov w2, #1
    sub w3, wzr, w2, lsl #31

    mov w4, #1
    sub w4, wzr, w4

    mov w5, #0
    sub w6, w5, #4095

    brk #0
