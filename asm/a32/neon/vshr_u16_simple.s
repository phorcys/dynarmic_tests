/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0004000400040004" }
}
*/
.text
.global _start
_start:
    @ VSHR.U16: Vector Shift Right (unsigned, immediate)
    @ VSHR d0, d1, #2
    
    mov r0, #16
    vdup.16 d1, r0          @ d1 = [16, 16, 16, 16] (4 halfwords)
    
    vshr.u16 d0, d1, #2     @ d0 = [16>>2, 16>>2, 16>>2, 16>>2] = [4, 4, 4, 4]
    
    bkpt #0