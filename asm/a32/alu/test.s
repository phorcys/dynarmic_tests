/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000009", "R1": "0x00020003", "R2": "0x00010002", "R3": "0x00000001" }
}
*/
.text
.global _start
_start:
    // SMLAD: Signed Multiply Accumulate Dual
    // R0 = (R1[15:0] * R2[15:0]) + (R1[31:16] * R2[31:16]) + R3
    // R1 = 0x00020003 = [hi=2, lo=3]
    // R2 = 0x00010002 = [hi=1, lo=2]
    // R3 = 1
    // R0 = (3*2) + (2*1) + 1 = 6 + 2 + 1 = 9

    ldr r1, =0x00020003  @ [hi=2, lo=3]
    ldr r2, =0x00010002  @ [hi=1, lo=2]
    mov r3, #1
    smlad r0, r1, r2, r3

    bkpt #0

.pool
