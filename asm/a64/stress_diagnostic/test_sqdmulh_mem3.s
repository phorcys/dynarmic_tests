/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x00010000",
    "W1": "1170"
  },
  "MemData": {
    "0x10000": "0x00000000EC98E1D7"
  }
}
*/
.text
.global _start
_start:
    // Memory layout at 0x10000:
    // [0x10000]: 0xE1D7 (low) = -7721
    // [0x10002]: 0xEC98 (low) = -4968
    
    ldr h0, [x0]        // Load -7721
    ldr h1, [x0, #2]    // Load -4968
    
    // SQDMULH h2, h0, h1
    sqdmulh h2, h0, h1
    
    // Move result to GPR
    smov w1, v2.H[0]
    brk #0
