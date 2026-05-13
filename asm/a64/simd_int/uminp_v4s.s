/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00000006000000020000000500000001" }
}
*/
.text
.global _start
_start:
    // UMINP (Unsigned Minimum Pairwise)
    // UMINP Vd.4S, Vn.4S, Vm.4S
    // Takes pairs within each vector and outputs the min of each pair
    // Result = [min(Vn[0],Vn[1]), min(Vn[2],Vn[3]), min(Vm[0],Vm[1]), min(Vm[2],Vm[3])]

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

    // UMINP: pairwise min within each vector
    // min(1,3)=1, min(5,7)=5, min(2,4)=2, min(6,8)=6
    // Result: [1, 5, 2, 6]
    uminp v0.4s, v0.4s, v1.4s

    brk #0