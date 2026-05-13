/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000006",
    "X1": "0x00000000FFFFFFFA",
    "X2": "0x00000000FFFFFFFB"
  }
}
*/
// 32-bit CINC/CINV/CNEG alias coverage.

.text
.global _start
_start:
    mov w3, #5

    cmp wzr, wzr
    cinc w0, w3, eq            // 5 + 1

    cmp wzr, wzr
    cinv w1, w3, eq            // ~5

    cmp wzr, wzr
    cneg w2, w3, eq            // -5

    brk #0
