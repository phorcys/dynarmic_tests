/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000001000000010000000100000001"
  }
}
*/
// Test: DUP Vd.4S, Vn.S[0] - duplicate element to all lanes
// V0.S[0] = 1, then duplicate to all 4 lanes

.text
.global _start
_start:
    // Set W0 = 1
    mov w0, #1

    // Move to V0.S[0]
    mov v0.s[0], w0

    // Duplicate S[0] to all lanes
    dup v0.4s, v0.s[0]

    brk #0
