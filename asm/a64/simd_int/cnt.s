/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000008"
  }
}
*/
// Test: CNT Xd, Xn - Count consecutive ones starting from bit 0
// Actually CNT is NEON count bits, not general register
// Let me use CNT for NEON

.text
.global _start
_start:
    // CNT is a NEON instruction - count set bits in each byte
    movi v0.16b, #0xFF     // all bits set in each byte
    
    cnt v0.16b, v0.16b      // count bits in each byte
    
    // Each byte should be 8 (0x08)
    // Extract first byte to X0
    umov w0, v0.b[0]

    brk #0
