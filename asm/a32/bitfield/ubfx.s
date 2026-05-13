/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x000000BC"
  }
}
*/
.text
.global _start
_start:
    // UBFX: Unsigned Bit Field Extract
    // UBFX Rd, Rn, #lsb, #width - extracts width bits starting at lsb, zero-extend
    ldr r1, =0x0000ABCD
    ubfx r0, r1, #4, #8   // Extract 8 bits starting at bit 4
    // 0xABCD = 0b1010_1011_1100_1101
    // bits 4-11: BC
    bkpt #0