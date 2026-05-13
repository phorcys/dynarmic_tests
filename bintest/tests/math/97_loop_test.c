// Loop and array test
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing loops...\n");
    
    // Test 1: Simple loop
    int sum = 0;
    for (int i = 0; i < 10; i++) {
        sum += i;
    }
    test_printstr("  sum: ");
    test_printint(sum);
    test_printstr("\n");
    TEST_ASSERT(sum == 45);  // 0+1+2+...+9 = 45
    
    // Test 2: Array copy
    unsigned char src[8] = {'A', 'B', 'A', 'B', 'A', 'B', 'A', 'B'};
    unsigned char dst[8];
    for (int i = 0; i < 8; i++) {
        dst[i] = src[i];
    }
    test_printstr("  copy: ");
    int match = 1;
    for (int i = 0; i < 8; i++) {
        if (dst[i] != src[i]) match = 0;
    }
    TEST_ASSERT(match);
    test_printstr("OK\n");
    
    // Test 3: Nested loop
    int count = 0;
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 3; j++) {
            count++;
        }
    }
    test_printstr("  nested: ");
    test_printint(count);
    test_printstr("\n");
    TEST_ASSERT(count == 15);
    
    // Test 4: Loop with condition
    int arr[10];
    for (int i = 0; i < 10; i++) arr[i] = 0;
    int pos = 0;
    for (int i = 0; i < 5; i++) {
        if (pos < 8) {
            arr[pos++] = i;
        }
    }
    test_printstr("  cond: ");
    test_printint(pos);
    test_printstr("\n");
    TEST_ASSERT(pos == 5);
    
    // Test 5: Loop with offset calculation
    int offset = 3;
    int start = 5 - offset;  // start = 2
    int result = 0;
    for (int j = 0; j < 3 && start + j < 5; j++) {
        result += start + j;  // 2 + 3 + 4 = 9
    }
    test_printstr("  offset: ");
    test_printint(result);
    test_printstr("\n");
    TEST_ASSERT(result == 9);
    
    // Test 6: Copy with overlap (like LZ77 decompress)
    unsigned char buf[16];
    for (int i = 0; i < 8; i++) buf[i] = 'A' + i;  // A B C D E F G H
    int buf_pos = 8;
    int back_offset = 2;
    int copy_len = 3;
    int copy_start = buf_pos - back_offset;  // 6
    for (int j = 0; j < copy_len && buf_pos < 16; j++) {
        buf[buf_pos] = buf[copy_start + j];
        buf_pos++;
    }
    test_printstr("  overlap: ");
    test_printint(buf_pos);  // Should be 11
    test_printstr("\n");
    TEST_ASSERT(buf_pos == 11);
    TEST_ASSERT(buf[8] == 'G');   // buf[6]
    TEST_ASSERT(buf[9] == 'H');   // buf[7]
    TEST_ASSERT(buf[10] == 'G');  // buf[8] - this was just written!
    
    test_printstr("All loop tests passed!\n");
    test_pass();
    return 0;
}
