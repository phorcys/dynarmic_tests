/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00010000",
    "W1": "-7721",
    "W2": "-4968"
  },
  "SetRegData": {
    "X0": "0x00010000"
  },
  "MemData": {
    "0x10000": "0xEC98E1D7"
  },
  "VecData": {
    "V0": ["0x000000000000E1D7", "0x0000000000000000"],
    "V1": ["0x000000000000EC98", "0x0000000000000000"]
  }
}
*/
.text
.global _start
_start:
    ldr h0, [x0]        // Load a into h0
    ldr h1, [x0, #2]    // Load b into h1
    
    // Check loaded values using smov
    smov w1, v0.H[0]    // w1 = a = -7721 = 0xFFFFE1D7
    smov w2, v1.H[0]    // w2 = b = -4968 = 0xFFFFEC98
    
    brk #0
