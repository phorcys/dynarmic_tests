/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00000008000000040000000700000003" }
}
*/
.text
.global _start
_start:
    // UMAXP (Unsigned Maximum Pairwise)
    // UMAXP Vd.4S, Vn.4S, Vm.4S
    // Takes pairs within each vector and outputs the max of each pair
    // Result = [max(Vn[0],Vn[1]), max(Vn[2],Vn[3]), max(Vm[0],Vm[1]), max(Vm[2],Vm[3])]

    // V0 = [1, 3, 5, 7]
    mov w0, #1
    ins v0.s[0], w0
    mov w1, #3
    ins v0.s[1], w1
    mov w2, #5
    ins v0.s[2], w2
    mov w3, #7
    ins v0.s[3], w3

    // V1 = [2, 4, 6, 8]
    mov w4, #2
    ins v1.s[0], w4
    mov w5, #4
    ins v1.s[1], w5
    mov w6, #6
    ins v1.s[2], w6
    mov w7, #8
    ins v1.s[3], w7

    // UMAXP: pairwise max within each vector
    // max(1,3)=3, max(5,7)=7, max(2,4)=4, max(6,8)=8
    // Result: [3, 7, 4, 8]
    umaxp v0.4s, v0.4s, v1.4s

    brk #0