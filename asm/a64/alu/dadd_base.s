/* CONFIG
{
  "Match": "All",
  "RegData": {
    "D0": "0x4008000000000000",
    "D1": "0x4010000000000000",
    "D2": "0x401C000000000000",
    "D3": "0x0000000000000000"
  }
}
*/
// Test: FADD - floating-point add (double precision)
// D0 = 3.0, D1 = 4.0, D2 = 3.0 + 4.0 = 7.0

.text
.global _start
_start:
    fmov d0, #3.0
    fmov d1, #4.0
    fadd d2, d0, d1
    
    mov x3, #0
    brk #0
