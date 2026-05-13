/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x01010101010101010101010102020101" }
}
*/
.text
.global _start
_start:
    @ VEXT: Extract vector elements
    @ VEXT.8 Q0, Q0, Q1, #2 - extract bytes
    mov r0, #1
    vdup.8 q0, r0      @ Q0 = [1,1,1,1,...]
    mov r0, #2
    vdup.8 q1, r0      @ Q1 = [2,2,2,2,...]
    vext.8 q0, q0, q1, #2
    @ Q0 = [1,1,2,2,...] (skip 2 bytes from Q0, take rest from Q1)
    bkpt #0