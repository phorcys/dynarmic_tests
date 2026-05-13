/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFF80",
    "X1": "0x0000000000000004",
    "X2": "0x000000000FFFFFF8",
    "X3": "0x0000000000000010",
    "X4": "0x000000000000FFFF"
  }
}
*/
// Test: ASRV - Arithmetic Shift Right Variable
// Note: mov w0, #-128 sets W0 to 0xFFFFFF80, but X0 upper bits are zeroed

.text
.global _start
_start:
    // W0 = -128 (0xFFFFFF80), X0 upper bits zeroed
    mov w0, #-128        // X0 = 0x00000000FFFFFF80
    
    // ASR by 4: 0xFFFFFF80 >> 4 = 0x0FFFFFF8 (arithmetic shift on 64-bit)
    // But since upper 32 bits are 0, sign bit is 0
    mov x1, #4
    asrv x2, x0, x1       // x2 = 0x000000000FFFFFF8
    
    // ASR by 16
    mov x3, #16
    asrv x4, x0, x3       // x4 = 0x000000000000FFFF

    brk #0
