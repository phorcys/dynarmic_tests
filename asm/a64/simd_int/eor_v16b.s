/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0xff00ff00ff00ff00ff00ff00ff00ff00",
    "Q1": "0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f",
    "Q2": "0xf00ff00ff00ff00ff00ff00ff00ff00f"
  }
}
*/
// Test: EOR Vd.16B, Vn.16B, Vm.16B - bitwise XOR

.text
.global _start
_start:
    // Load Q0 with pattern 0xFF00FF00... (alternating bytes)
    mov w0, #0xff00
    dup v0.8h, w0
    
    // Load Q1 with pattern 0x0F0F... (low nibbles)
    mov w1, #0x0f0f
    dup v1.8h, w1
    
    // EOR: Q2 = Q0 ^ Q1
    // 0xFF ^ 0x0F = 0xF0
    // 0x00 ^ 0x0F = 0x0F
    // Result: 0xF00F 0xF00F... = [0xf0, 0x0f, 0xf0, 0x0f, ...]
    eor v2.16b, v0.16b, v1.16b

    brk #0