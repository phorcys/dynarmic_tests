/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFF0000",
    "X1": "0x0000000000007FFF"
  }
}
*/
// Test: SBFIZ Xd, Xn, #lsb, #width - Signed Bit Field Insert in Zero
// Insert bit field from source into zero, then sign-extend

.text
.global _start
_start:
    mov x0, #0
    
    // Insert signed bit field: take 16 bits from source, place at position 16
    // Source value: 0xFFFF (all 1s in lower 16 bits)
    mov x2, #0xFFFF
    sbfiz x0, x2, #16, #16
    // Take 16 bits from x2[15:0] = 0xFFFF
    // Place at position 16, zero-extend initially
    // Then sign-extend from bit 31 (the highest bit of inserted field)
    // bit 31 = 1 (from 0xFFFF), so sign-extend to all 1s above
    // Result: bits [63:32] = 0xFFFFFFFF, bits [31:16] = 0xFFFF, bits [15:0] = 0
    // X0 = 0xFFFFFFFFFFFF0000

    // Test with positive value (bit 15 = 0, no sign extension)
    mov x1, #0
    mov x2, #0x7FFF
    sbfiz x1, x2, #0, #16
    // Take 16 bits from x2[15:0] = 0x7FFF
    // Place at position 0
    // Sign-extend from bit 15 = 0 (positive in 16-bit view)
    // Result: bits [63:16] = 0, bits [15:0] = 0x7FFF
    // X1 = 0x7FFF

    brk #0
