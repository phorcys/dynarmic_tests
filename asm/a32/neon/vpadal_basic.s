/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0002000800020008" }
}
*/
.text
.global _start
_start:
    @ VPADAL: Pairwise Add and Accumulate
    @ VPADAL.<size> Vd, Vm
    @ Vd = Vd + PairwiseAdd(Vm)
    @ For .u16: widen to 32-bit, add pairs, accumulate
    
    mov r0, #2
    vdup.16 d0, r0       @ D0 = [2, 2, 2, 2] (4 x 16-bit)
    
    mov r0, #3
    vdup.16 d1, r0       @ D1 = [3, 3, 3, 3] (4 x 16-bit)
    
    vpadal.u16 d0, d1    @ D0 = pairwise_add(D1) + D0
                         @ D1 pairs: [3+3, 3+3] = [6, 6] as 32-bit
                         @ D0 was [2, 2, 2, 2] as 16-bit
                         @ Result: [2, 2+6, 2, 2+6] = [2, 8, 2, 8]
    
    bkpt #0
