/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xDEF09ABC56781234"
  }
}
*/
// Test: Write and read back TPIDR_EL0
// Note: movk builds value with highest shift in highest bits
.text
.global _start
_start:
    mov x0, #0x1234         // bits [15:0]
    movk x0, #0x5678, lsl #16   // bits [31:16]
    movk x0, #0x9ABC, lsl #32   // bits [47:32]
    movk x0, #0xDEF0, lsl #48   // bits [63:48]
    msr tpidr_el0, x0
    mrs x1, tpidr_el0
    mov x0, x1       // X0 = TPIDR_EL0 value
    brk #0
