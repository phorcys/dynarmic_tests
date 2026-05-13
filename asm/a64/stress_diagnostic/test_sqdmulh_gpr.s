/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0xFFFFE1D7",
    "X1": "0x00000496",
    "X2": "0"
  },
  "VecData": {
    "V2": ["0x0000000000000496", "0"]
  }
}
*/
.text
.global _start
_start:
    // Load h0 = -7721, h1 = -4984 using mov
    mov w0, #0xE1D7
    movk w0, #0xFFFF, lsl #16   // w0 = -7721
    mov w1, #0xEC88
    movk w1, #0xFFFF, lsl #16   // w1 = -4984
    
    // Move to V registers
    dup v0.4h, w0
    dup v1.4h, w1
    
    // SQDMULH h2, h0, h1 -> result = 1174 (0x0496)
    sqdmulh h2, h0, h1
    
    // Move result to GPR using unsigned
    umov w1, v2.H[0]
    brk #0
