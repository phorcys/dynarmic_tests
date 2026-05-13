/* CONFIG
{
  "Match": "All",
  "Q0": "0x05ba7e3138e98f05caa38e5ef25729ee"
}
*/
// Test: SHA256H2 Qd, Qn, Vm.4S - SHA256 hash update 2

.text
.global _start
_start:
    // Initialize test data
    mov w0, #0x1234
    movk w0, #0x5678, lsl #16
    mov v0.s[0], w0
    mov v0.s[1], w0
    mov v0.s[2], w0
    mov v0.s[3], w0
    
    mov v1.16b, v0.16b
    mov v2.16b, v0.16b
    
    // SHA256H2: SHA256 hash update 2
    sha256h2 q0, q1, v2.4s
    
    brk #0
