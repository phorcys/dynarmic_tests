/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    // SBFX: Signed Bit Field Extract
    // SBFX Rd, Rn, #lsb, #width - extracts width bits starting at lsb, sign-extend
    ldr r1, =0x0000ABF8
    sbfx r0, r1, #4, #4   // Extract 4 bits starting at bit 4
    // 0xF8 = 0b1111_1000
    // bits 4-7 = 0b1111 = 0xF = -1 (signed 4-bit)
    // Sign-extended to 32-bit: 0xFFFFFFFF
    bkpt #0
