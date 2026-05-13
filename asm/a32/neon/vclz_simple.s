/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000002000000004" }
}
*/
.text
.global _start
_start:
    @ VCLZ - Count Leading Zeros per element
    @ 0x0F000000 has 4 leading zeros (for 32-bit element)
    @ 0x00000000 has 32 leading zeros
    ldr r0, =0x0F000000
    mov r1, #0
    vmov d0, r0, r1      @ D0 = 0x000000000F000000
    vclz.i32 d0, d0
    bkpt #0
.ltorg
