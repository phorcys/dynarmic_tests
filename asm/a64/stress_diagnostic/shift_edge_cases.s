/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001",
    "X2": "0xFFFFFFFFFFFFFFFF",
    "X3": "0x0000000000000001",
    "X4": "0xFFFFFFFFFFFFFFFF",
    "X5": "0x0000000000001234"
  }
}
*/
// Test: Shift edge cases
// For register shifts (LSLV/LSRV/ASRV), shift amount is modulo 64
// So shift by 64 is equivalent to shift by 0 (no shift)

.text
.global _start
_start:
    // === Test 1: LSLV by 64 (modulo 64 = 0, no shift) ===
    mov x8, #1
    mov x9, #64
    lslv x10, x8, x9         // 1 << 0 = 1
    mov x1, x10
    
    // === Test 2: LSRV by 64 (modulo 64 = 0, no shift) ===
    mov x8, #-1              // All 1s
    mov x9, #64
    lsrv x10, x8, x9         // all 1s >> 0 = all 1s
    mov x2, x10
    
    // === Test 3: ASRV by 64 (modulo 64 = 0, no shift) ===
    mov x8, #1               // Positive
    mov x9, #64
    asrv x10, x8, x9         // 1 >> 0 = 1
    mov x3, x10
    
    // === Test 4: ASRV by 64 on negative (modulo 64 = 0, no shift) ===
    mov x8, #-1
    mov x9, #64
    asrv x10, x8, x9         // -1 >> 0 = -1
    mov x4, x10
    
    // === Test 5: LSL by 0 (immediate) ===
    mov x8, #0x1234
    lsl x10, x8, #0          // No shift
    mov x5, x10              // Should be 0x1234
    
    mov x0, #0

    brk #0
