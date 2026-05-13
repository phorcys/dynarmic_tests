/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f",
    "Q2": "0xf0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0"
  }
}
*/
// Test: RBIT Vd.16B, Vn.16B - reverse bits

.text
.global _start
_start:
    // Load Q0 with pattern 0x0F (00001111 in binary)
    mov w0, #0x0f0f
    dup v0.8h, w0
    
    // RBIT: reverse bits in each byte
    // 0x0F (00001111) -> 0xF0 (11110000)
    rbit v2.16b, v0.16b

    brk #0
