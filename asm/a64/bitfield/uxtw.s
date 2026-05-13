/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/
// Test: UXTW Xd, Wn - Unsigned Extend Word
// Zero-extends a 32-bit word to 64-bit

.text
.global _start
_start:
    mov w0, #0xFF
    movk w0, #0xFF00, lsl #16   // W0 = 0xFFFF
    
    mov x0, #0
    mov w1, #0xFF
    
    // UXTW: zero-extend W1 to X0
    uxtw x0, w1
    // X0 = 0xFF (zero-extended)

    brk #0
