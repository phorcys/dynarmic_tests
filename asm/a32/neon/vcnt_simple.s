/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000000004" }
}
*/
.text
.global _start
_start:
    @ VCNT - Count Set Bits per byte
    mov r0, #0x0F
    mov r1, #0
    vmov d0, r0, r1      @ D0 = 0x000000000000000F
    vcnt.8 d0, d0
    bkpt #0
.ltorg
