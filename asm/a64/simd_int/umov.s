/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: UMOV Wd, Vn.B[index] - Unsigned Move Vector Element
// Moves a vector element to a general register (unsigned)

.text
.global _start
_start:
    movi v0.16b, #42
    
    // UMOV: extract byte 0 from V0 to W0
    umov w0, v0.b[0]
    
    // W0 = 42

    brk #0
