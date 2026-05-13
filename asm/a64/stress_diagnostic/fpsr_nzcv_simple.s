/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000070000000",
    "X1": "0x0000000000000000",
    "X2": "0x000000000000001F"
  }
}
*/
.text
.global _start
_start:
    // AArch64: FPSR and NZCV are separate registers!
    // FPSR contains only exception flags (bits 4:0) and QC (bit 27)
    // NZCV is accessed via the NZCV system register

    // Save original
    mrs x3, fpsr
    mrs x4, nzcv

    // Test 1: Set NZCV directly
    mov x0, #0x07
    lsl x0, x0, #28          // x0 = 0x70000000
    msr nzcv, x0
    mrs x0, nzcv             // Should be 0x70000000

    // Test 2: FPSR should NOT contain NZCV in AArch64
    mrs x1, fpsr             // Should be 0 (only exception flags)

    // Test 3: Set exception flags in FPSR
    mov x5, #0x1F            // All exception flags
    msr fpsr, x5
    mrs x2, fpsr             // Should be 0x1F

    // Restore
    msr fpsr, x3
    msr nzcv, x4

    brk #0
