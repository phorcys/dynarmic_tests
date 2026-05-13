/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234"
  }
}
*/
// Test: STLR - Store-Release Register (offset must be 0)

.text
.global _start
_start:
    sub sp, sp, #16
    mov x0, #0x1234
    stlr x0, [sp]
    
    // Load back to verify
    ldr x0, [sp]

    brk #0
