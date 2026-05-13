/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x0000000000000064",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: BL - branch with link

.text
.global _start
_start:
    mov x0, #0
    bl subroutine
    mov x2, #0               // x2 = 0
    b done
subroutine:
    mov x0, #42              // x0 = 42
    mov x1, #100             // x1 = 100
    ret
done:
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
