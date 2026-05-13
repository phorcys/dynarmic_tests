/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x000000000000002A",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: CBZ - compare and branch if zero

.text
.global _start
_start:
    mov x0, #0
    cbz x0, is_zero
    mov x1, #0               // skipped
    b done
is_zero:
    mov x1, #42              // x1 = 42
done:
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
