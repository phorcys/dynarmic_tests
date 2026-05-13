/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xFFFFF0FF"
  }
}
*/
.text
.global _start
_start:
    // BFC: Bit Field Clear
    // BFC Rd, #lsb, #width - clears width bits starting at lsb
    ldr r0, =0xFFFFFFFF
    bfc r0, #8, #4   // Clear 4 bits at position 8 (bits 8-11)
    bkpt #0
