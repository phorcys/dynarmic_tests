/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0xff00ff00ff00ff00ff00ff00ff00ff00",
    "Q1": "0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f",
    "Q2": "0xff0fff0fff0fff0fff0fff0fff0fff0f"
  }
}
*/
// Test: ORR Vd.16B, Vn.16B, Vm.16B - bitwise OR

.text
.global _start
_start:
    // Load Q0 with pattern 0xFF00FF00... (alternating bytes)
    mov w0, #0xff00
    dup v0.8h, w0
    
    // Load Q1 with pattern 0x0F0F... (low nibbles)
    mov w1, #0x0f0f
    dup v1.8h, w1
    
    // ORR: Q2 = Q0 | Q1
    // 0xFF | 0x0F = 0xFF
    // 0x00 | 0x0F = 0x0F
    // Result: 0xFF0F 0xFF0F... = [0xff, 0x0f, 0xff, 0x0f, ...]
    orr v2.16b, v0.16b, v1.16b

    brk #0