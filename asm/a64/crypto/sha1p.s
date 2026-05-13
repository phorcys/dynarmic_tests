/* CONFIG
{
  "Match": "All",
  "Q0": "0x9efc9abc3a98dd441ed91f4351c3d811"
}
*/
// Test: SHA1P Qd, Sn, Vm.4S - SHA1 hash update (parity)

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
    
    // SHA1P: SHA1 hash update parity
    sha1p q0, s1, v2.4s
    
    brk #0
