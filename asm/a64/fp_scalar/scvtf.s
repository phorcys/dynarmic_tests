/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040400000"
  }
}
*/
// Test: SCVTF - Signed Integer Convert to Floating-point

.text
.global _start
_start:
    mov x0, #3
    
    // SCVTF: convert 3 to float = 3.0
    scvtf s0, x0
    
    fmov w0, s0

    brk #0
