/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0x0000000000000003",
    "X2": "0x0000000000000005",
    "X3": "0x00000000FFFFFFFF",
    "X4": "0x0000000000000007"
  }
}
*/
// Test: Conditional Select (CSEL, CSINC, CSINV, CSNEG)
// These instructions don't set flags, but depend on condition flags

.text
.global _start
_start:
    // Set up initial flags: N=0, Z=0, C=1, V=0 (0x20000000)
    mov w11, #1
    cmp w11, #0              // 1 > 0, N=0, Z=0, C=1, V=0

    // Test 1: CSEL (Conditional Select)
    // CSEL Wd, Wn, Wm, cond: if cond then Wn else Wm
    mov w12, #1
    mov w13, #2
    csel w14, w12, w13, eq   // EQ false (Z=0), so w14 = w13 = 2
    mov w0, w14              // x0 = 2

    // Test 2: CSEL with HI condition (C=1)
    mov w12, #3
    mov w13, #4
    csel w14, w12, w13, hi   // HI true (C=1), so w14 = w12 = 3
    mov w1, w14              // x1 = 3

    // Test 3: CSINC (Conditional Select Increment)
    // CSINC Wd, Wn, Wm, cond: if cond then Wn else (Wm + 1)
    mov w12, #4
    mov w13, #4
    csinc w14, w12, w13, eq  // EQ false, so w14 = w13 + 1 = 5
    mov w2, w14              // x2 = 5

    // Test 4: CSINV (Conditional Select Invert)
    // CSINV Wd, Wn, Wm, cond: if cond then Wn else (~Wm)
    mov w12, #6
    mov w13, #0
    csinv w14, w12, w13, eq  // EQ false, so w14 = ~w13 = ~0 = -1 = 0xFFFFFFFF
    mov w3, w14              // x3 = 0xFFFFFFFF

    // Test 5: CSNEG (Conditional Select Negate)
    // CSNEG Wd, Wn, Wm, cond: if cond then Wn else (-Wm)
    mov w12, #7
    mov w13, #8
    csneg w14, w12, w13, hi  // HI true (C=1), so w14 = w12 = 7
    mov w4, w14              // x4 = 7

    brk #0