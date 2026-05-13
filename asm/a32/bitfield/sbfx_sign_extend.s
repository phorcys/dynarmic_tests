/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12348078",
    "R1": "0xFFFFFF80",
    "R2": "0x00000078",
    "R3": "0xFFFFFF48"
  }
}
*/
// Test: SBFX - Signed Bit Field Extract with sign extension
// SBFX Rd, Rn, #lsb, #width: Extract width bits from Rn starting at lsb, sign-extend

.text
.arm
.global _start
_start:
    @ Setup: load a value with negative byte
    ldr r0, =0x12348078     @ Bits [15:8] = 0x80 (negative in signed 8-bit)
    
    @ Test 1: Extract bits [15:8] = 0x80, sign-extend
    sbfx r1, r0, #8, #8     @ r1 = sign-extend(0x80) = 0xFFFFFF80 = -128
    
    @ Test 2: Extract bits [7:0] = 0x78 (positive in signed 8-bit)
    sbfx r2, r0, #0, #8     @ r2 = 0x78
    
    @ Test 3: Extract bits [20:12] = 9 bits
    @ 0x12348078 >> 12 = 0x12348
    @ bits [8:0] of 0x12348 = 0x148 (9 bits)
    @ bit 8 = 1, so negative: sign-extend to 0xFFFFFF48
    sbfx r3, r0, #12, #9    @ r3 = 0xFFFFFF48
    
    bkpt #0
