/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00040004000600060003000300030003"
  }
}
*/
.text
.global _start
_start:
    @ VPADD: Pairwise Add
    @ vpadd.i16 d0, d0, d1
    @ D0 = [d0[0]+d0[1], d0[2]+d0[3], d1[0]+d1[1], d1[2]+d1[3]]
    mov r0, #2
    mov r1, #3
    vdup.16 d0, r0    @ D0 = [2, 2, 2, 2] (4 x 16-bit)
    vdup.16 d1, r1    @ D1 = [3, 3, 3, 3]
    vpadd.i16 d0, d0, d1  @ D0 = [2+2, 2+2, 3+3, 3+3] = [4, 4, 6, 6]
    @ Q0 = D1:D0, D1 is unchanged [3,3,3,3]
    @ Result: Q0 = [3,3,3,3,4,4,6,6] as 16-bit elements
    @ In hex: 0x00030003000300030004000400060006
    bkpt #0
