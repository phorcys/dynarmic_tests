/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x00010000",
    "W1": "0x0000E1D7"
  },
  "MemData": {
    "0x10000": "0xEC98E1D7"
  }
}
*/
.text
.global _start
_start:
    ldr h0, [x0]        // Load 2 bytes into h0 (V0 low 16 bits)
    
    // Move the half-word to GPR using umov (unsigned)
    umov w1, v0.h[0]
    
    brk #0
