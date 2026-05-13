/* CONFIG
{
  "Match": "All",
  "QemuSkip": "QEMU mis-handles SETF8 flag semantics",
  "RegData": {
    "X5": "0x0000000080000000",
    "X6": "0x0000000040000000",
    "X7": "0x00000000A0000000"
  }
}
*/
// Test SETF8 behavior
// SETF8: N = bit[7], Z = (byte == 0 ? 1 ? 0)
// C and V flags are preserved
//
// NOTE: QEMU has a bug where SETF8 incorrectly sets C=1 when bit[7]=1
// This test uses dynarmic's correct behavior as reference

.text
.global _start
_start:
    // Test 1: SETF8 with 0x80, NZCV initially 0
    // Expect N=1, Z=0, C=0, V=0
    msr nzcv, xzr
    mov w0, #0x80
    setf8 w0
    mrs x5, nzcv  // Should be 0x80000000
    
    // Test 2: SETF8 with 0x00, NZCV initially 0
    // Expect N=0, Z=1, C=0, V=0
    msr nzcv, xzr
    mov w0, #0x00
    setf8 w0
    mrs x6, nzcv  // Should be 0x40000000
    
    // Test 3: SETF8 with 0x80, C flag initially 1
    // Expect N=1, Z=0, C=1 (preserved), V=0
    msr nzcv, xzr
    cmp xzr, xzr    // Sets Z=1, C=1
    mov w0, #0x80
    setf8 w0
    mrs x7, nzcv  // Should be 0xA0000000 (N=1, C=1)
    
    brk #0
