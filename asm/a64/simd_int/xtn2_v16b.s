/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000010000700030001",
    "Q1": "0x00000000000000001122334455667788",
    "Q2": "0x00000000100703011122334455667788"
  }
}
*/
// Test: XTN2 Vd.16B, Vn.8H - extract narrow to high half

.text
.global _start
_start:
    // Load Q0 with halfwords
    mov w0, #1
    mov w1, #3
    mov w2, #7
    mov w3, #16
    mov v0.h[0], w0
    mov v0.h[1], w1
    mov v0.h[2], w2
    mov v0.h[3], w3
    mov v0.d[1], xzr
    
    // Load Q1 with existing data
    ldr x1, =0x1122334455667788
    fmov d1, x1
    mov v1.d[1], xzr
    
    // XTN2: truncate halfwords to bytes, store in high half of Vd
    mov v2.16b, v1.16b  // copy Q1 to Q2
    xtn2 v2.16b, v0.8h  // narrow Q0's halfwords to Q2's high bytes

    brk #0
