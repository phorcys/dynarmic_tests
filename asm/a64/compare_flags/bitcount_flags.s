/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000001F",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000001"
  }
}
*/
// Test: Bit manipulation (CLZ, RBIT, REV)
// These don't set flags in ARM64

.text
.global _start
_start:
    // Test 1: CLZ (Count Leading Zeros)
    // CLZ Wd, Wn: count zeros from MSB
    mov w11, #1
    clz w13, w11             // 0x00000001 has 31 leading zeros (32-bit)
    mov w0, w13              // x0 = 31 = 0x1F

    // Test 2: RBIT (Reverse Bits)
    // RBIT Wd, Wn: reverse bit order
    mov w11, #0x10           // 0x10 = 00010000 in bits [7:0]
    rbit w13, w11            // Reverse: bit[4] -> bit[27]
    // Result is non-zero, check it
    cmp w13, #0
    cset w1, eq              // w1 = 0 (w13 != 0)

    // Test 3: REV (Reverse bytes)
    // REV Wd, Wn: reverse byte order
    mov w11, #0x01
    orr w11, w11, #0x0200    // bits [15:8] = 0x02
    rev w13, w11             // reverse byte order
    and w2, w13, #0xFF       // x2 = low byte (should be 0x00)

    // Test 4: REV16 (Reverse bytes in halfwords)
    mov w11, #0x01
    orr w11, w11, #0x0200
    rev16 w13, w11           // Swap bytes in each halfword
    lsr w3, w13, #8          // x3 = bits[15:8] (should be 0x01)

    brk #0
