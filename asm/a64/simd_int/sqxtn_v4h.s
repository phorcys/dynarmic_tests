/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x7FFFFFFF000000017FFFFFFF00000001",
    "D1": "0x7FFF00017FFF0001"
  }
}
*/
// Test: SQXTN Vd.4H, Vn.4S - saturating extract narrow (signed)

.text
.global _start
_start:
    // Load Q0 with [1, MAX, 1, MAX] as 32-bit elements
    mov w0, #1
    mov v0.s[0], w0
    
    mov w1, #0xFFFF
    movk w1, #0x7FFF, lsl #16  // 0x7FFFFFFF (MAX)
    mov v0.s[1], w1
    
    mov v0.s[2], w0
    mov v0.s[3], w1
    
    // SQXTN: saturating truncate 32-bit to 16-bit
    sqxtn v1.4h, v0.4s

    brk #0
