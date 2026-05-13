/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0xff00ff00ff00ff00ff00ff00ff00ff00",
    "Q1": "0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f",
    "Q2": "0xffffffffffffffffffffffffffffffff",
    "Q3": "0xff00ff00ff00ff00ff00ff00ff00ff00"
  }
}
*/
// Test: BSL Vd.16B, Vn.16B, Vm.16B - bitwise select
// BSL: For each bit, if Vd bit is 1, select from Vn, else from Vm

.text
.global _start
_start:
    // Load Q0 with pattern 0xFF00FF00...
    mov w0, #0xff00
    dup v0.8h, w0
    
    // Load Q1 with pattern 0x0F0F...
    mov w1, #0x0f0f
    dup v1.8h, w1
    
    // Load Q2 with all 1s (select all from Q0)
    mov w2, #-1
    dup v2.8h, w2
    
    // BSL: Vd = selector, Vn = if-true, Vm = if-false
    // If Q2 bit is 1, select Q0 bit; else select Q1 bit
    // Since Q2 is all 1s, result should be Q0
    mov v3.16b, v2.16b
    bsl v3.16b, v0.16b, v1.16b

    brk #0
