/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000FAA0", "R1": "0x000000AA" }
}
*/
.text
.global _start
_start:
    // BFI: Bit Field Insert
    // BFI Rd, Rn, #lsb, #width - Insert width bits from Rn into Rd starting at lsb
    ldr r0, =0x0000F0F0
    mov r1, #0xAA     @ 0xAA = 10101010

    @ Insert 8 bits from R1 into R0 starting at bit 4
    bfi r0, r1, #4, #8
    @ Clear bits [11:4] of R0, then insert R1[7:0]
    @ R0 = 0x0000F0F0 -> clear [11:4] -> 0x0000F000
    @ Insert 0xAA at bit 4: 0x0000F000 | (0xAA << 4) = 0x0000FAA0

    bkpt #0

.pool