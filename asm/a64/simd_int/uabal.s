/* CONFIG
{
  "Match": "All",
  "RegData": { "S0": "0x00000007" }
}
*/
.text
.global _start
_start:
    // UABAL (Unsigned Absolute difference and Accumulate Long)
    // UABAL Vd.4S, Vn.4H, Vm.4H

    // Initialize accumulator to 0
    movi v0.4s, #0

    // Test: 16-bit elements
    movi v1.4h, #10             // v1 = [10, 10, 10, 10] as 16-bit
    movi v2.4h, #3              // v2 = [3, 3, 3, 3] as 16-bit
    uabal v0.4s, v1.4h, v2.4h   // v0.s = [7, 7, 7, 7]

    brk #0
