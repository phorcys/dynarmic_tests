/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x00010000",
    "W1": "-7721",
    "W2": "-4968",
    "W3": "1170"
  },
  "MemData": {
    "0x10000": "0xEC98E1D7"
  }
}
*/
.text
.global _start
_start:
    // Memory layout: [0x10000]: a (2 bytes), [0x10002]: b (2 bytes)
    // a = 0xE1D7 = -7721, b = 0xEC98 = -4968
    
    ldr h0, [x0]        // Load a into h0
    ldr h1, [x0, #2]    // Load b into h1
    
    // Verify loaded values using smov (sign-extend move)
    smov w1, v0.H[0]    // w1 = a = -7721
    smov w2, v1.H[0]    // w2 = b = -4968
    
    // SQDMULH
    sqdmulh h3, h0, h1
    smov w3, v3.H[0]    // w3 = result = 1170
    
    brk #0
