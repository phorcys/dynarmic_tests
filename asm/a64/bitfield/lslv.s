/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000010",
    "X2": "0x0000000000010000",
    "X3": "0x0000000000000020",
    "X4": "0x0000000100000000"
  }
}
*/
// Test: LSLV - Logical Shift Left Variable

.text
.global _start
_start:
    mov x0, #1
    
    // LSL by 16: 1 << 16 = 0x10000
    mov x1, #16
    lslv x2, x0, x1       // x2 = 0x10000
    
    // LSL by 32: 1 << 32 = 0x100000000
    mov x3, #32
    lslv x4, x0, x3       // x4 = 0x100000000

    brk #0
