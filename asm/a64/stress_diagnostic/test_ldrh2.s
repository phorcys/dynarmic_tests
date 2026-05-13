/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x00010000",
    "X1": "0xE1D7"
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
    
    // Move h0 to GPR to check value (ins element to GPR)
    // umov w1, v0.h[0] gives unsigned, smov w1, v0.h[0] gives signed
    umov w1, v0.h[0]
    brk #0
