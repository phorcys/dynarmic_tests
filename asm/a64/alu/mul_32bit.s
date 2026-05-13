/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FFFF",
    "X1": "0x000000000000FFFF",
    "X2": "0x00000000FFFE0001",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: MUL - 32-bit (W registers)

.text
.global _start
_start:
    mov w0, #0xFFFF
    mov w1, #0xFFFF
    mul w2, w0, w1           // 0xFFFF * 0xFFFF = 0xFFFE0001 (32-bit)
    
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
