/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000020000000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000060000000"
  }
}
*/
.text
.global _start
_start:
    // Test CMP with immediate values

    // Test 1: Compare equal values
    mov x11, #42
    cmp x11, #42                // 42 - 42 = 0
    mrs x0, nzcv
    // Expected: N=0, Z=1, C=1, V=0 -> 0x60000000

    // Test 2: Compare greater (unsigned)
    mov x11, #100
    cmp x11, #50                // 100 - 50 = 50
    mrs x1, nzcv
    // Expected: N=0, Z=0, C=1, V=0 -> 0x20000000

    // Test 3: Compare less (unsigned)
    mov x11, #50
    cmp x11, #100               // 50 - 100 = -50
    mrs x2, nzcv
    // Expected: N=1, Z=0, C=0, V=0 -> 0x80000000

    // Test 4: Compare with zero
    mov x11, #0
    cmp x11, #0                 // 0 - 0 = 0
    mrs x3, nzcv
    // Expected: N=0, Z=1, C=1, V=0 -> 0x60000000

    brk #0