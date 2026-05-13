/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000100000000",
    "X1": "0x0000000000000010",
    "X2": "0x0000000000010000",
    "X3": "0x0000000000000020",
    "X4": "0x0000000000000001"
  }
}
*/
// Test: LSRV - Logical Shift Right Variable

.text
.global _start
_start:
    // X0 = 0x100000000
    mov x0, #1
    lsl x0, x0, #32
    
    // LSR by 16: 0x100000000 >> 16 = 0x10000
    mov x1, #16
    lsrv x2, x0, x1       // x2 = 0x10000
    
    // LSR by 32: 0x100000000 >> 32 = 1
    mov x3, #32
    lsrv x4, x0, x3       // x4 = 1

    brk #0