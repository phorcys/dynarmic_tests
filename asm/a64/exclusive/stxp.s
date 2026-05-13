/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// Test: STXP - Store Exclusive Pair
// Note: QEMU user-mode returns status=1 (fail) for exclusive operations
// because there's no exclusive monitor set

.text
.global _start
_start:
    // Prepare data
    mov x1, #0x1111
    mov x2, #0x2222
    
    // Allocate stack space
    sub sp, sp, #16
    
    // Store exclusive pair (returns status in w0)
    stxp w0, x1, x2, [sp]

    brk #0