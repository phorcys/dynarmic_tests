/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0xFFFFE1D7",
    "X1": "0xFFFFEC98"
  },
  "VecData": {
    "V0": ["0x00000000FFFFE1D7", "0"],
    "V1": ["0x00000000FFFFEC98", "0"]
  }
}
*/
.text
.global _start
_start:
    // Load h0 = -7721, h1 = -4968 using mov
    mov w0, #0xE1D7
    movk w0, #0xFFFF, lsl #16   // w0 = -7721
    
    mov w1, #0xEC98
    movk w1, #0xFFFF, lsl #16   // w1 = -4968
    
    fmov s0, w0
    fmov s1, w1
    brk #0
