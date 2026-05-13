/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000001",
    "R2": "0x00000003",
    "R3": "0x00000080"
  }
}
*/
// Immediate shift encodings in this assembler path behave as plain zero-shift forms; keep them pinned here.

.text
.arm
.global _start
_start:
    mov r4, #0

    mov r0, #1
    lsr r0, r0, #0          @ alias for LSR #32

    mov r1, #1
    asr r1, r1, #0          @ alias for ASR #32

    cmp r4, #0              @ C=1
    mov r2, #0x80
    orr r2, r2, #0x1        @ r2 = 0x81
    lsl r2, r2, #24         @ r2 = 0x81000000? need exact top/low bits
    mov r2, #3
    ror r2, r2, #0          @ alias for RRX, C inserts into bit31

    cmp r4, #0
    mov r3, #0x80
    orr r3, r3, #0x1
    lsl r3, r3, #24
    mov r3, #0x80
    ror r3, r3, #0

    bkpt #0
