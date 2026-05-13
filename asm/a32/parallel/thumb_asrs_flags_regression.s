/* CONFIG
{
  "Match": "All",
  "Bucket": "fuzz_cpsr",
  "SourceRepro": "batch_single_001/cpsr_sample.json",
  "SetCpsr": "0xD00001F0",
  "SetFpscr": "0x03080000",
  "ExpectedCpsr": "0xB00001F0",
  "ExpectedFpscr": "0x03000000",
  "SetRegData": {
    "R0": "0xEF9D80C4",
    "R1": "0xE6A45A5C",
    "R2": "0x387C2F2F",
    "R3": "0xE68ABCC2",
    "R4": "0xBAF52132",
    "R5": "0xC7793F7B",
    "R6": "0x42B7506A",
    "R7": "0x5958DA81",
    "R8": "0xE9171649",
    "R9": "0xAD7BD1BE",
    "R10": "0x3F259AE0",
    "R11": "0xDC9BEE8D",
    "R12": "0x831387C4",
    "SP": "0x01D8F2E9",
    "LR": "0x057FF6A4"
  },
  "ExpectedRegData": {
    "R0": "0xEF9D80C4",
    "R1": "0xE6A45A5C",
    "R2": "0x387C2F2F",
    "R3": "0xE68ABCC2",
    "R4": "0xBAF52132",
    "R5": "0xFFF9A916",
    "R6": "0x42B7506A",
    "R7": "0x5958DA81",
    "R8": "0xE9171649",
    "R9": "0xAD7BD1BE",
    "R10": "0x3F259AE0",
    "R11": "0xDC9BEE8D",
    "R12": "0x831387C4",
    "SP": "0x01D8F2E9",
    "LR": "0x057FF6A4"
  }
}
*/
.text
.syntax unified
.thumb
.global _start
_start:
    asrs r5, r1, #10
    bkpt #0
