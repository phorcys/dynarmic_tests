/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x60000000",
    "X1": "0x40000000",
    "X2": "0x60000000",
    "X3": "0x60000000"
  }
}
*/
// Test: Zero results and Z flag
// Z flag is set when result is zero

.text
.global _start
_start:
    // Test 1: SUB to zero (self-subtraction)
    mov w11, #0x1234
    subs w12, w11, w11
    // N=0, Z=1, C=1, V=0 -> 0x60000000
    mrs x0, nzcv

    // Test 2: ANDS to zero
    mov w11, #0xFFFF0000
    mov w12, #0x0000FFFF
    ands w13, w11, w12
    // N=0, Z=1, C=0, V=0 -> 0x40000000
    mrs x1, nzcv

    // Test 3: SUB immediate to zero
    mov w11, #42
    subs w12, w11, #42
    // N=0, Z=1, C=1, V=0 -> 0x60000000
    mrs x2, nzcv

    // Test 4: CMP equal values
    mov w11, #100
    cmp w11, #100
    // N=0, Z=1, C=1, V=0 -> 0x60000000
    mrs x3, nzcv

    brk #0
