/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005"
  }
}
*/
// Test: CSINV - Conditional Select Invert

.text
.global _start
_start:
    mov x0, #5
    mov x1, #10
    cmp xzr, xzr          // Z=1
    csinv x0, x0, x1, eq  // if Z=1 then x0 else ~x1 = 5

    brk #0
