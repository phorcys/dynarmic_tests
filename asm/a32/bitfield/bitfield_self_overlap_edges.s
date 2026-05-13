/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000123",
    "R1": "0x0000FFFF",
    "R2": "0xFFFFFF80",
    "R3": "0x12347878"
  }
}
*/
// Bitfield overlap edges: Rd==Rn and source reuse cases.

.arch armv7-a
.text
.arm
.global _start
_start:
    ldr r0, =0x00000123
    bfi r0, r0, #0, #8      @ self insert low byte into itself

    ldr r1, =0x000000FF
    bfi r1, r1, #8, #8      @ copy low byte upward with Rd==Rn

    ldr r2, =0x80000000
    sbfx r2, r2, #24, #8    @ extract sign-extended 0x80

    ldr r3, =0x12345678
    bfc r3, #8, #8
    bfi r3, r3, #8, #8      @ reinsert cleared byte from same register snapshot path

    bkpt #0
