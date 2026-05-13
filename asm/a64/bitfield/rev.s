/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0403020100000000"
  }
}
*/
// Test: REV - Reverse Bytes

.text
.global _start
_start:
    // X0 = 0x0000000001020304
    movz x0, #0x0304
    movk x0, #0x0102, lsl #16
    
    // REV: reverse byte order
    rev x0, x0

    brk #0
