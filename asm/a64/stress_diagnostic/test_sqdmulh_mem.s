/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x00010000",
    "X1": "0"
  },
  "MemData": {
    "0x10000": "0x771DEC88FFFFE1D7"
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
    
    // Move result to GPR
    smov w1, v2.H[0]
    brk #0
