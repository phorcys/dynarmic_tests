/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xF0000000",
    "X1": "0x00000000",
    "X2": "0x20000000",
    "X3": "0x10000000"
  }
}
*/
// Test: MSR/MRS NZCV - Direct flag manipulation
// NZCV register can be read/written directly

.text
.global _start
_start:
    // Test 1: Set all flags via MSR
    // NZCV = N|Z|C|V = 0xF0000000
    mov x11, #0xF0000000
    msr nzcv, x11
    mrs x0, nzcv            // x0 = 0xF0000000

    // Test 2: Clear all flags
    msr nzcv, xzr           // Write zero to NZCV
    mrs x1, nzcv            // x1 = 0x00000000

    // Test 3: Set only C flag
    mov x11, #0x20000000    // C flag bit
    msr nzcv, x11
    mrs x2, nzcv            // x2 = 0x20000000

    // Test 4: Set only V flag
    mov x11, #0x10000000    // V flag bit
    msr nzcv, x11
    mrs x3, nzcv            // x3 = 0x10000000

    brk #0
