/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000007FFFFFFF",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000003",
    "X3": "0x0000000000000009"
  }
}
*/
// UDIV 32-bit edge coverage: max values, divide-by-zero, truncation, overlap.

.text
.global _start
_start:
    mov w0, #0xFFFFFFFF
    mov w4, #2
    udiv w0, w0, w4             // overlap: 0xFFFFFFFF / 2 = 0x7FFFFFFF

    mov w1, #123
    mov w4, #0
    udiv w1, w1, w4             // divide by zero -> 0

    mov w2, #10
    mov w4, #3
    udiv w2, w2, w4             // 3

    mov w3, #81
    mov w4, #9
    udiv w3, w3, w4             // 9

    brk #0
