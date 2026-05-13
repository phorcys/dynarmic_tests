/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// Test: CSEL with NE condition

.text
.global _start
_start:
    mov x0, #1
    mov x1, #5
    cmp x0, #0
    csel x0, x0, x1, ne   // x0=1, x1=5, if x0!=0 then x0 else x1 = 1

    brk #0
