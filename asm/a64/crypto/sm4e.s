/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SM4E Vd.4S, Vn.4S - SM4 encryption

.text
.global _start
_start:
    // Initialize with zeros
    movi v0.4s, #0
    
    // SM4E: SM4 encryption round
    sm4e v0.4s, v0.4s
    
    brk #0
