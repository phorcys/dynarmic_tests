/* CONFIG
{
  "Match": "All",
  "RegData": { "S0": "0x3f800000", "D1": "0x3ff0000000000000" }
}
*/
.text
.global _start
_start:
    // Half-precision (FP16) conversion tests
    // These test the FCVT instruction for H<->S<->D conversions
    // Note: FP16 arithmetic requires ARMv8.2-A, but conversions are supported

    // === Test 1: Single to Double (S -> D) ===
    fmov s0, #1.0
    fcvt d1, s0             // Convert S to D
    // d1 should be 1.0 in double = 0x3ff0000000000000

    // === Test 2: Double to Single (D -> S) ===
    fmov d2, #2.0
    fcvt s3, d2             // Convert D to S
    // s3 should be 2.0 in single = 0x40000000

    // === Test 3: Single to Single (identity) ===
    fmov s0, #1.0
    // s0 should be 1.0 = 0x3f800000

    // === Test 4: Double to Double (identity) ===
    fmov d1, #1.0
    // d1 should be 1.0 = 0x3ff0000000000000

    brk #0