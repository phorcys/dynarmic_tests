/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x00000000FFFFFFFF",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000005",
    "X4": "0x00000000FFFFFFFA",
    "X5": "0x00000000FFFFFFFB"
  }
}
*/
// NGC result-only coverage for 32-bit carry-in behavior.

.text
.global _start
_start:
    mov w0, #0
    mov x8, #0

    cmp x8, #1
    ngc w1, w0                  // 0 - 0 - 1 = -1

    cmp xzr, xzr
    ngc w2, w0                  // 0 - 0 - 0 = 0

    mov w3, #5
    cmp x8, #1
    ngc w4, w3                  // 0 - 5 - 1 = -6

    cmp xzr, xzr
    ngc w5, w3                  // 0 - 5 - 0 = -5

    brk #0
