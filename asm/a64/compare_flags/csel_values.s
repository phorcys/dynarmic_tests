/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000029",
    "X1": "0x0000000000000029",
    "X2": "0x000000000000002A",
    "X3": "0x000000000000002A"
  }
}
*/
// Test: Conditional select (CSEL)

.text
.global _start
_start:
    // Set up flags: N=0, Z=0, C=1, V=0
    mov w11, #1
    cmp w11, #0              // 1 > 0, C=1

    // Test 1: CSEL with HI (unsigned higher) - true
    mov w12, #41
    mov w13, #42
    csel w14, w12, w13, hi   // HI true (C=1, Z=0), w14 = w12 = 41
    mov w0, w14

    // Test 2: CSEL with EQ (equal) - false
    mov w12, #42
    mov w13, #41
    csel w14, w12, w13, eq   // EQ false (Z=0), w14 = w13 = 41
    mov w1, w14

    // Test 3: CSEL with LO (unsigned lower) - false
    mov w12, #43
    mov w13, #42
    csel w14, w12, w13, lo   // LO false (C=1), w14 = w13 = 42
    mov w2, w14

    // Test 4: CSEL with NE (not equal) - true
    mov w12, #42
    mov w13, #99
    csel w14, w12, w13, ne   // NE true (Z=0), w14 = w12 = 42
    mov w3, w14

    brk #0
