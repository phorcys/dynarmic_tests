/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q3": "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: BIT Vd.16B, Vn.16B, Vm.16B - bitwise insert if true
// BIT: if mask bit is 1, insert bit from source into destination

.text
.global _start
_start:
    // Load Q0 with destination (all 0s)
    mov x0, #0
    mov v0.d[0], x0
    mov v0.d[1], x0
    
    // Load Q1 with source (all 1s)
    mov x1, #-1
    mov v1.d[0], x1
    mov v1.d[1], x1
    
    // Load Q2 with mask (all 1s)
    mov v2.d[0], x1
    mov v2.d[1], x1
    
    // Copy Q0 to Q3
    mov v3.16b, v0.16b
    
    // BIT: if mask bit is 1, insert bit from source
    // Since mask is all 1s, all bits from source (all 1s) will be inserted
    bit v3.16b, v1.16b, v2.16b

    brk #0