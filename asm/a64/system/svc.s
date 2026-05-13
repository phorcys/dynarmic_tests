/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: SVC #imm - Supervisor Call
// Causes a supervisor call exception
// Note: Cannot test actual SVC in user-mode QEMU

.text
.global _start
_start:
    mov x0, #42
    
    // SVC would cause a supervisor call exception
    // In user-mode QEMU, this would cause an error
    // We skip it for now

    brk #0
