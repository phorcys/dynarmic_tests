/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00010001000100010000000100000001" }
}
*/
.text
.global _start
_start:
    @ VMOVN: Vector Narrow
    @ VMOVN.I16 D0, Q0 - narrow 32-bit to 16-bit
    mov r0, #1
    vdup.32 q0, r0    @ Q0 = [1,1,1,1] as 32-bit
    vmovn.i16 d0, q0  @ D0 = [1,1,1,1] as 16-bit (only low half)
    bkpt #0
