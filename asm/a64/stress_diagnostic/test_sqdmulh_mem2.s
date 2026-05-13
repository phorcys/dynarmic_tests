/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x00010000",
    "X1": "0",
    "X2": "0"
  },
  "MemData": {
    "0x10000": "0x771DEC88FFFFE1D7"
  },
  "VecData": {
    "V2": ["0", "0"]
  }
}
*/
.text
.global _start
_start:
    // Load h0 = -7721 (0xE1D7), h1 = -4968 (0xEC88)
    ldr h0, [x0]
    ldr h1, [x0, #2]
    
    // SQDMULH h2, h0, h1 should give 1170
    sqdmulh h2, h0, h1
    
    // Move result to GPR using unsigned
    umov w1, v2.H[0]
    
    // Also check using smov
    smov x2, v2.H[0]
    brk #0
