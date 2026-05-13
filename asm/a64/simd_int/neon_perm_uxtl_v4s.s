/* CONFIG
{
  "Match": "All",
  "RegData": {
    "D0": "0x0000000000020001",
    "Q1": "0x00000000000000000000000200000001"
  }
}
*/
// Test: UXTL Vd.4S, Vn.4H - zero-extend 16-bit to 32-bit

.text
.global _start
_start:
    // Load D0 with [1, 2] as 16-bit elements
    mov w0, #1
    mov v0.h[0], w0
    mov w1, #2
    mov v0.h[1], w1
    
    // UXTL: zero-extend 16-bit to 32-bit
    uxtl v1.4s, v0.4h

    brk #0
