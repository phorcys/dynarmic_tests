/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000000000000"
  }
}
*/
// Edge case test: ccmp_basic
// cmp w0, #10: 5 < 10, so N=0, Z=0, C=1, V=0 -> NZCV=0x20000000
// ccmp w0, #3, #0, ge: condition ge is false (5 >= 10 is false), so NZCV = #0 = 0x00000000

.text
.global _start
_start:

    mov w0, #5
    cmp w0, #10       // 5 < 10, so N=0, C=1
    ccmp w0, #3, #0, ge  // condition ge is false, set NZCV = 0
    mrs x1, nzcv      // NZCV = 0


    brk #0
