/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x3FC03FC03F803F804040404040004000",
    "Q1": "0x00000000000000003E023C0242024002"
  }
}
*/
// Test: FCVTN Vd.4H, Vn.4S - floating-point convert single to half

.text
.global _start
_start:
    // Load Q0 with single-precision values: 2.0, 3.0, 1.0, 1.5
    mov w0, #0x4000
    movk w0, #0x4000, lsl #16
    mov v0.s[0], w0
    mov w1, #0x4040
    movk w1, #0x4040, lsl #16
    mov v0.s[1], w1
    mov w2, #0x3F80
    movk w2, #0x3F80, lsl #16
    mov v0.s[2], w2
    mov w3, #0x3FC0
    movk w3, #0x3FC0, lsl #16
    mov v0.s[3], w3
    
    // FCVTN: convert single to half
    fcvtn v1.4h, v0.4s

    brk #0
