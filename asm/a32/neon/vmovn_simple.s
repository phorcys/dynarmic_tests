/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0001000100000000" }
}
*/
.text
.global _start
_start:
    @ VMOVN.I16: Vector Move Narrow
    @ Narrows 32-bit to 16-bit
    
    mov r0, #0
    vdup.32 d2, r0          @ d2 = [0, 0]
    mov r0, #1
    vdup.32 d3, r0          @ d3 = [1, 1]
    
    vmovn.i16 d0, q1        @ d0 = narrow(q1) = narrow(d2:d3)
    
    bkpt #0