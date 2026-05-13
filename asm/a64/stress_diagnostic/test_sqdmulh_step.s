/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "W0": "0xFFFFE1D7",
    "W1": "0xFFFFEC98",
    "W2": "0x492",
    "W3": "0xFFFFEC98"
  }
}
*/
.text
.global _start
_start:
    // Load -7721 into w0 as 16-bit value
    mov w0, #0xE1D7
    movk w0, #0xFFFF, lsl #16   // w0 = -7721 (32-bit signed)
    
    // Load -4968 into w1
    mov w1, #0xEC98
    movk w1, #0xFFFF, lsl #16   // w1 = -4968 (32-bit signed)
    
    // Extract low 16 bits (simulating what VectorGetElement16 does)
    // This gives unsigned 16-bit values
    uxth w2, w0    // w2 = 0x0000E1D7 (unsigned extract)
    uxth w3, w1    // w3 = 0x0000EC98 (unsigned extract)
    
    // Now sign extend (simulating la_ext_w_h)
    sxth w2, w2    // w2 = 0xFFFFE1D7 = -7721
    sxth w3, w3    // w3 = 0xFFFFEC98 = -4968
    
    // Multiply
    mul w2, w2, w3   // w2 = (-7721) * (-4968) = 38359128
    
    // Shift right 15
    lsr w2, w2, #15   // w2 = 38359128 >> 15 = 1170
    
    // w2 should be 1170
    brk #0
