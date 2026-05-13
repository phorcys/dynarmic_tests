/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x0000000000000015",
    "X2": "0x00000000FFFFFFEB",
    "X3": "0x00000000FFFFFFEB"
  }
}
*/
// 32-bit CSEL/CSINC/CSINV/CSNEG coverage.

.text
.global _start
_start:
    mov w4, #42
    mov w5, #20
    mov w6, #21

    cmp wzr, wzr
    csel w0, w4, w5, eq

    cmp wzr, wzr
    csinc w1, w4, w5, ne

    cmp wzr, wzr
    csinv w2, w4, w5, ne

    cmp wzr, wzr
    csneg w3, w4, w6, ne

    brk #0
