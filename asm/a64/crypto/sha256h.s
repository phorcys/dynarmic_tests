/* CONFIG
{
  "Match": "All",
  "Q0": "0x6a2ee445fc1b8cd3ea104c97650300a0"
}
*/
// Test: SHA256H Qd, Qn, Vm.4S - SHA256 hash update

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
    
    // SHA256H: SHA256 hash update
    sha256h q0, q1, v2.4s
    
    brk #0
