/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000002A",
    "R1": "0x00000064",
    "R2": "0x0000008E",
    "R3": "0x00000032",
    "R4": "0x0000044C"
  }
}
*/
// Test: ADD - basic register and immediate forms (A32 version)

.text
.arm
.global _start
_start:
    mov r0, #42
    mov r1, #100
    add r2, r0, r1          @ 42 + 100 = 142 = 0x8E
    add r3, r0, #8          @ 42 + 8 = 50 = 0x32
    add r4, r1, #1000       @ 100 + 1000 = 1100 = 0x44C

    bkpt #0
