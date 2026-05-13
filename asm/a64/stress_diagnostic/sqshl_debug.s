/* CONFIG
{
  "Match": "All",
  "QemuSkip": "This diagnostic test relies on local .data labels that the QEMU runner wrapper does not preserve",
  "Q0": "0x7F7F7FF8C0800000",
  "Q1": "0x090A0C03050D0B04"
}
*/
// Test SQSHL.8B with specific test data
// Result should be [0, INT8_MIN, INT8_MAX, -64, -8, INT8_MAX, INT8_MAX, INT8_MAX]

.text
.global _start
_start:
    // Load test data
    // a = [0, -3, 1, -2, -1, 87, 6, 8] as bytes
    adr x0, data_a
    ldr d0, [x0]
    
    // b = [4, 11, 13, 5, 3, 12, 10, 9] as bytes
    adr x0, data_b
    ldr d1, [x0]
    
    // SQSHL.8B
    sqshl v0.8b, v0.8b, v1.8b
    
    brk #0

.data
.align 8
data_a:
    .byte 0, 253, 1, 254, 255, 87, 6, 8
data_b:
    .byte 4, 11, 13, 5, 3, 12, 10, 9
