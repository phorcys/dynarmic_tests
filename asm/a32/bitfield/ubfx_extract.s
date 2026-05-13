/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x00000012",
    "R2": "0x00000056",
    "R3": "0x00000078"
  }
}
*/
// Test: UBFX - Unsigned Bit Field Extract
// UBFX Rd, Rn, #lsb, #width: Extract width bits from Rn starting at lsb

.text
.arm
.global _start
_start:
    @ Setup: load a value
    ldr r0, =0x12345678
    
    @ Test 1: Extract bits [31:24] (top byte)
    ubfx r1, r0, #24, #8    @ r1 = 0x12
    
    @ Test 2: Extract bits [15:8] (second byte)
    ubfx r2, r0, #8, #8     @ r2 = 0x56
    
    @ Test 3: Extract bits [7:0] (low byte)
    ubfx r3, r0, #0, #8     @ r3 = 0x78
    
    @ r0 unchanged = 0x12345678
    
    bkpt #0
