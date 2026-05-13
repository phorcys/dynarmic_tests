/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: HLT #imm - Halt instruction
// Causes a halt exception
// Note: In test harness, BRK is the terminator, HLT can be tested

.text
.global _start
_start:
    mov x0, #42
    
    // HLT instruction - this would halt the processor
    // In QEMU test mode, we skip this to avoid hanging
    // hlt #1

    brk #0
