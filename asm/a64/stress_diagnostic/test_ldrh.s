/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x00010000",
    "X1": "0x496"
  },
  "MemData": {
    "0x10000": "0x00000000EC88E1D7"
  }
}
*/
.text
.global _start
_start:
    // Load h0 = -7721 (0xE1D7), h1 = -4984 (0xEC88)
    ldr h0, [x0]
    ldr h1, [x0, #2]
    
    // SQDMULH h0, h0, h1 should give 1174 (0x0496)
    sqdmulh h0, h0, h1
    
    // Sign extend to GPR
    smov x1, v0.H[0]
    brk #0
