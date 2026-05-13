/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000003" }
}
*/
.text
.global _start
_start:
    // VZIP: Vector Zip (interleaves two vectors)
    // Initialize D0, D1 (Q0) with simple pattern
    vmov.i32 d0, #1
    vmov.i32 d1, #2
    vmov.i32 d2, #3
    vmov.i32 d3, #4

    vzip.32 q0, q1
    vmov.32 r0, d0[1]
    bkpt #0
