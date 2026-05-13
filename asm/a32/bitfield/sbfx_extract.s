/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x00000056",
    "R2": "0x00000078",
    "R3": "0x00000012"
  }
}
*/
// Test: SBFX - Signed Bit Field Extract
// SBFX Rd, Rn, #lsb, #width: Extract width bits from Rn starting at lsb, sign-extend

.text
.arm
.global _start
_start:
    @ Setup: load a value
    ldr r0, =0x12345678
    
    @ Test 1: Extract bits [15:8] - positive value (0x56, bit 7 = 0)
    sbfx r1, r0, #8, #8     @ r1 = 0x56 (sign bit = 0, no extension)
    
    @ Test 2: Extract bits [7:0] - positive (0x78, bit 7 = 0)
    sbfx r2, r0, #0, #8     @ r2 = 0x78
    
    @ Test 3: Extract high byte
    sbfx r3, r0, #24, #8    @ r3 = 0x12
    
    @ r0 unchanged = 0x12345678
    
    bkpt #0
