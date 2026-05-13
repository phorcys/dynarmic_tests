/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00000002000000020000000200000002" }
}
*/
.text
.global _start
_start:
    @ VSHLL: Shift Left Long
    @ VSHLL.S16 Q0, D0, #1 - shift left and widen
    mov r0, #1
    vdup.16 d0, r0
    vshll.s16 q0, d0, #1
    @ D0[16-bit] << 1 = 2, extended to 32-bit
    bkpt #0
