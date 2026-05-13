/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003",
    "S1": "0x40400000",
    "D2": "0x4008000000000000",
    "X3": "0x0000000000000000"
  }
}
*/
// Test: UCVTF - unsigned integer to floating-point
// X0 = 3, S1 = 3.0 (single), D2 = 3.0 (double)

.text
.global _start
_start:
    mov x0, #3
    ucvtf s1, x0
    ucvtf d2, x0
    
    mov x3, #0
    brk #0
