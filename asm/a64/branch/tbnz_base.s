/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
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
// Test: TBNZ - test bit and branch if not zero

.text
.global _start
_start:
    mov x0, #1
    tbnz x0, #0, not_zero    // bit 0 is one
    mov x1, #0               // skipped
    b done
not_zero:
    mov x1, #42
done:
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
