/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000003E003E0042003C00",
    "Q1": "0x3FC000003FC00000404000003F800000"
  }
}
*/
// Test: FCVTL Vd.4S, Vn.4H - floating-point convert half to single

.text
.global _start
_start:
    // Load Q0 with half-precision values: 1.0, 3.0, 1.5, 1.5
    // Half: 1.0 = 0x3C00, 3.0 = 0x4200, 1.5 = 0x3E00
    mov w0, #0x3C00
    mov v0.h[0], w0
    mov w1, #0x4200
    mov v0.h[1], w1
    mov w2, #0x3E00
    mov v0.h[2], w2
    mov w3, #0x3E00
    mov v0.h[3], w3
    
    // FCVTL: convert half to single
    fcvtl v1.4s, v0.4h

    brk #0
