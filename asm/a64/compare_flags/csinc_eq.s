/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000064"
  }
}
*/
// CSINC when condition true: EQ=true, select X1 (no increment)

.text
.global _start
_start:
    mov x1, #100
    mov x2, #200
    cmp x0, x0      // Z=1
    csinc x0, x1, x2, eq  // EQ true -> x0 = x1 = 100
    brk #0
