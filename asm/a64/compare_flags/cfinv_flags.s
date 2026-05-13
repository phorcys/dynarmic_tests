/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x20000000",
    "X1": "0x00000000",
    "X2": "0x30000000",
    "X3": "0xB0000000",
    "X4": "0x60000000",
    "X5": "0x40000000"
  }
}
*/
// Test: CFINV - Invert Carry Flag (ARMv8.4-A)
// CFINV inverts the C flag (bit 29 of NZCV)
// NZCV format: N=bit31, Z=bit30, C=bit29, V=bit28

.text
.global _start
_start:
    // Test 1: CFINV with C=0 -> C becomes 1
    // Start with NZCV = 0x00000000 (N=0, Z=0, C=0, V=0)
    // After CFINV: NZCV = 0x20000000 (N=0, Z=0, C=1, V=0)
    mov x10, #0
    msr nzcv, x10
    cfinv
    mrs x0, nzcv

    // Test 2: CFINV with C=1 -> C becomes 0
    // Start with NZCV = 0x20000000 (N=0, Z=0, C=1, V=0)
    // After CFINV: NZCV = 0x00000000 (N=0, Z=0, C=0, V=0)
    mov x10, #0x20000000
    msr nzcv, x10
    cfinv
    mrs x1, nzcv

    // Test 3: CFINV preserves other flags (N, Z, V)
    // Start with NZCV = 0x10000000 (N=0, Z=0, C=0, V=1)
    // After CFINV: NZCV = 0x30000000 (N=0, Z=0, C=1, V=1)
    mov x10, #0x10000000
    msr nzcv, x10
    cfinv
    mrs x2, nzcv

    // Test 4: CFINV with all flags set except C
    // Start with NZCV = 0x90000000 (N=1, Z=0, C=0, V=1)
    // After CFINV: NZCV = 0xB0000000 (N=1, Z=0, C=1, V=1)
    mov x10, #0x90000000
    msr nzcv, x10
    cfinv
    mrs x3, nzcv

    // Test 5: CFINV with Z=1 and C=0
    // Start with NZCV = 0x40000000 (N=0, Z=1, C=0, V=0)
    // After CFINV: NZCV = 0x60000000 (N=0, Z=1, C=1, V=0)
    mov x10, #0x40000000
    msr nzcv, x10
    cfinv
    mrs x4, nzcv

    // Test 6: CFINV with Z=1 and C=1
    // Start with NZCV = 0x60000000 (N=0, Z=1, C=1, V=0)
    // After CFINV: NZCV = 0x40000000 (N=0, Z=1, C=0, V=0)
    mov x10, #0x60000000
    msr nzcv, x10
    cfinv
    mrs x5, nzcv

    brk #0
