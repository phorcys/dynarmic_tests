/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x000000000000000000ff0100007f001f",
    "Q2": "0x000000000000000000000000ffff7f1f"
  }
}
*/
// Test: SQXTUN Vd.8B, Vn.8H - saturating extract unsigned narrow

.text
.global _start
_start:
    // Load Q0 with halfwords that test saturation
    // [0x1f, 0x7f, 0x100, 0xff] -> [0x1f, 0x7f, 0xff, 0xff] after saturation
    mov w0, #0x1f
    mov w1, #0x7f
    mov w2, #0x100  // > 255, will saturate to 0xff
    mov w3, #0xff
    mov v0.h[0], w0
    mov v0.h[1], w1
    mov v0.h[2], w2
    mov v0.h[3], w3
    mov v0.d[1], xzr
    
    // SQXTUN: signed saturating extract to unsigned narrow
    // Values > 255 saturate to 255, values < 0 saturate to 0
    sqxtun v2.8b, v0.8h

    brk #0
