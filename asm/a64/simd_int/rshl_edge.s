/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000",
  "Q1": "0x00000000000000000000000000000000"
}
*/
// Test: RSHL edge cases
// V0: shift by +64 (overflow left shift) => should be 0
// V1: shift by -64 (shift value = 192 as 8-bit signed = -64) => right shift by 64, should be 0

.text
.global _start
_start:
    // Test large positive shift (should left shift, but overflow => 0)
    mov w0, #1
    dup v0.4s, w0          // V0 = {1, 1, 1, 1}
    mov w1, #64            // shift by 64
    dup v2.4s, w1          // V2 = {64, 64, 64, 64}
    urshl v0.4s, v0.4s, v2.4s  // Expected: 0 (shift >= bit_size)
    
    // Test large negative shift (should right shift by 64 => 0)
    mov w3, #1
    dup v1.4s, w3          // V1 = {1, 1, 1, 1}
    mov w4, #192           // 192 = -64 as signed 8-bit
    dup v3.4s, w4          // V3 = {192, 192, 192, 192}
    urshl v1.4s, v1.4s, v3.4s  // Expected: 0 (shift < -bit_size, right shift by 64)
    
    brk #0
