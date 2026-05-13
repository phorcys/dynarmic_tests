/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000345"
  }
}
*/
// Test: BFXIL Xd, Xn, #lsb, #width - Bit Field Extract and Insert Low
// Extract bit field from source and insert into low bits of destination

.text
.global _start
_start:
    mov x0, #0
    
    // Create source value: 0x12345678
    mov x1, #0x5678
    movk x1, #0x1234, lsl #16
    
    // Extract 12 bits from x1[23:12] and insert into x0[11:0]
    // x1 = 0x12345678
    // bits [23:12] of x1 = bits 12-23 = 0x345
    // Insert into x0[11:0]
    // X0 = 0x345
    bfxil x0, x1, #12, #12

    brk #0