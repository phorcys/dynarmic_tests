/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0xff00ff00ff00ff00ff00ff00ff00ff00",
    "Q1": "0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f",
    "Q2": "0xf000f000f000f000f000f000f000f000"
  }
}
*/
// Test: BIC Vd.16B, Vn.16B, Vm.16B - bitwise AND NOT

.text
.global _start
_start:
    // Load Q0 with pattern 0xFF00FF00... (alternating bytes)
    mov w0, #0xff00
    dup v0.8h, w0
    
    // Load Q1 with pattern 0x0F0F... (low nibbles)
    mov w1, #0x0f0f
    dup v1.8h, w1
    
    // BIC: Q2 = Q0 & ~Q1
    // 0xFF & ~0x0F = 0xFF & 0xF0 = 0xF0
    // 0x00 & ~0x0F = 0x00 & 0xF0 = 0x00
    // Result: 0xF000 0xF000... = [0xf0, 0x00, 0xf0, 0x00, ...]
    bic v2.16b, v0.16b, v1.16b

    brk #0