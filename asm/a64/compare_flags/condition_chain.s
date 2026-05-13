/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0x000000000000000A",
    "X2": "0x0000000000000005",
    "X3": "0x000000000000000A"
  }
}
*/
.text
.global _start
_start:
    // Test complex condition chains

    // Test 1: CSEL with EQ condition
    mov w11, #5
    mov w12, #5
    cmp w11, w12               // 5 == 5, Z=1
    csel w0, w11, w12, eq      // EQ true (Z==1), w0 = w11 = 5

    // Test 2: CSEL with GE condition (signed greater or equal)
    mov w11, #10
    mov w12, #5
    cmp w11, w12               // 10 > 5, N=0, Z=0, C=1, V=0
    // GE: N==V -> true (0==0)
    csel w1, w11, w12, ge      // w1 = 10

    // Test 3: CSEL with LT condition (signed less than)
    // Same flags from previous CMP: N=0, Z=0, C=1, V=0
    // LT: N!=V -> false (0==0)
    csel w2, w11, w12, lt      // w2 = 5 (condition false)

    // Test 4: CSEL with GT condition (signed greater than)
    // GT: Z==0 && N==V -> true (Z=0 && 0==0)
    csel w3, w11, w12, gt      // w3 = 10

    brk #0