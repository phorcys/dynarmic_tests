/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00000015000000150000001500000015" }
}
*/
.text
.global _start
_start:
    // SABAL (Signed Absolute difference and Accumulate Long)
    // SABAL Vd.4S, Vn.4H, Vm.4H

    movi v0.4s, #0              // Reset accumulator

    // Signed values: 10 and 3
    mov w0, #10
    dup v1.4h, w0
    mov w1, #3
    dup v2.4h, w1

    sabal v0.4s, v1.4h, v2.4h   // v0.s = [7, 7, 7, 7]
    sabal v0.4s, v1.4h, v2.4h   // v0.s = [14, 14, 14, 14]
    sabal v0.4s, v2.4h, v1.4h   // v0.s += abs(3-10) = 7 -> [21, 21, 21, 21]

    brk #0