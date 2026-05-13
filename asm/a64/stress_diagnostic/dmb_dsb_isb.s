/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x000000000000002A",
    "X2": "0x000000000000002A",
    "X3": "0x000000000000002A",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: DMB/DSB/ISB - memory barriers

.text
.global _start
_start:
    mov x0, #42
    dmb sy
    mov x1, x0
    dsb sy
    mov x2, x1
    isb
    mov x3, x2
    // These are barrier instructions, should not change register values
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
