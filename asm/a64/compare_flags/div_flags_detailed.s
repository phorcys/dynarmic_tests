/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000040000000",
    "X2": "0x0000000080000000"
  }
}
*/
.text
.global _start
_start:
    // Test division followed by flags checking

    // Test 1: Normal division
    mov w11, #100
    mov w12, #7
    udiv w13, w11, w12         // 100 / 7 = 14
    adds w14, w13, #0          // Check flags on 14
    mrs x0, nzcv
    // Expected: N=0, Z=0, C=0, V=0 -> 0x00000000

    // Test 2: Division resulting in zero
    mov w11, #5
    mov w12, #10
    udiv w13, w11, w12         // 5 / 10 = 0
    adds w14, w13, #0          // Check flags on 0
    mrs x1, nzcv
    // Expected: N=0, Z=1, C=0, V=0 -> 0x40000000

    // Test 3: Signed division with negative result
    mov w11, #10
    neg w12, w12               // w12 = -10 (from previous value)
    sdiv w13, w11, w12         // 10 / -10 = -1
    adds w14, w13, #0          // Check flags on -1 (0xFFFFFFFF)
    mrs x2, nzcv
    // Expected: N=1, Z=0, C=0, V=0 -> 0x80000000

    brk #0
