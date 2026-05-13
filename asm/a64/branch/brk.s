/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: BRK #imm - Breakpoint instruction
// Causes a breakpoint exception
// Note: In QEMU test harness, BRK is used as test terminator

.text
.global _start
_start:
    mov x0, #42
    
    // BRK is the test terminator, so we can't execute it before the end
    // This test just verifies we can have code before brk

    brk #0
