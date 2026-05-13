/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: SMOV Wd, Vn.B[index] - Signed Move Vector Element
// Moves a vector element to a general register (signed)

.text
.global _start
_start:
    movi v0.16b, #42
    
    // SMOV: extract byte 0 from V0 to W0 (sign-extended)
    smov w0, v0.b[0]
    
    // W0 = 42 (positive, no sign extension needed)

    brk #0
