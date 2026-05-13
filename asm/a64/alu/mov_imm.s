/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x0000000000000000",
    "X2": "0x000000000000FFFF",
    "X3": "0x0000000000000FFF",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: MOV - immediate forms

.text
.global _start
_start:
    mov x0, #42
    mov x1, #0
    mov x2, #65535
    mov x3, #4095
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
