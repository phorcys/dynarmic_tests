/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0000000100000001" }
}
*/
.text
.global _start
_start:
    @ VCVT between float and integer
    @ VCVT.S32.F32 - convert float to signed int (round to zero)
    
    mov r0, #1
    vdup.32 d0, r0       @ D0 = [1, 1]
    
    vcvt.f32.s32 d0, d0  @ D0 = [1.0, 1.0]
    
    vcvt.s32.f32 d0, d0  @ D0 = [1, 1] (back to int)
    
    bkpt #0
