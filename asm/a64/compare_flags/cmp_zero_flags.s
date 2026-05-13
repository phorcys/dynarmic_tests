/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000080000000",
    "X3": "0x00000000A0000000"
  }
}
*/
// Test: CMP with zero - various comparisons against zero

.text
.global _start
_start:
    // Test 1: CMP positive, 0
    mov w11, #42
    cmp w11, #0              // 42 - 0 = 42, N=0, Z=0, C=1, V=0
    mrs x0, nzcv             // x0 = 0x20000000

    // Test 2: CMP 0, 0
    mov w11, #0
    cmp w11, #0              // 0 - 0 = 0, N=0, Z=1, C=1, V=0
    mrs x1, nzcv             // x1 = 0x60000000

    // Test 3: CMP 0, positive
    mov w12, #42
    cmp w11, w12             // 0 - 42 = -42, N=1, Z=0, C=0, V=0
    mrs x2, nzcv             // x2 = 0x80000000

    // Test 4: CMP negative, 0
    mov w11, #0xFFFFFFFF     // -1
    cmp w11, #0              // -1 - 0 = -1, N=1, Z=0, C=1, V=0
    mrs x3, nzcv             // x3 = 0xA0000000

    brk #0