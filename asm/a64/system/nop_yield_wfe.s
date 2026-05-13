/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x000000000000002A",
    "X2": "0x000000000000002A",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: NOP/YIELD/WFE - hint instructions

.text
.global _start
_start:
    mov x0, #42
    nop
    mov x1, x0
    yield
    mov x2, x1
    // These are hint instructions, should not change behavior
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
