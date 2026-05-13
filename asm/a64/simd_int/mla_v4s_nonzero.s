/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0xFFFFFFFCFFFFFFFDFFFFFFFEFFFFFFFF"
  }
}
*/
// Test: MLS Vd.4S, Vn.4S, Vm.4S - vector multiply-subtract with non-zero accumulator

.text
.global _start
_start:
    // Load V0 with [1, 2, 3, 4] (accumulator)
    mov w0, #1
    mov v0.s[0], w0
    mov w0, #2
    mov v0.s[1], w0
    mov w0, #3
    mov v0.s[2], w0
    mov w0, #4
    mov v0.s[3], w0

    // Load V1 with [2, 2, 2, 2]
    mov w0, #2
    mov v1.s[0], w0
    mov v1.s[1], w0
    mov v1.s[2], w0
    mov v1.s[3], w0

    // Load V2 with [1, 2, 3, 4]
    mov w0, #1
    mov v2.s[0], w0
    mov w0, #2
    mov v2.s[1], w0
    mov w0, #3
    mov v2.s[2], w0
    mov w0, #4
    mov v2.s[3], w0

    // MLS: V0 -= V1 * V2
    // [1,2,3,4] - [2,2,2,2] * [1,2,3,4]
    // = [1,2,3,4] - [2,4,6,8]
    // = [-1, -2, -3, -4]
    // S[0] = -1 = 0xFFFFFFFF
    // S[1] = -2 = 0xFFFFFFFE
    // S[2] = -3 = 0xFFFFFFFD
    // S[3] = -4 = 0xFFFFFFFC
    mls v0.4s, v1.4s, v2.4s

    brk #0