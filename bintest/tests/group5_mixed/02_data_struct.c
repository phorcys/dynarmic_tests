// Test data structure operations
#include "test_syscall.h"

struct Node {
    int value;
    struct Node* next;
};

int list_sum(struct Node* head) {
    int sum = 0;
    while (head) {
        sum += head->value;
        head = head->next;
    }
    return sum;
}

int list_max(struct Node* head) {
    if (!head) return 0;
    int max = head->value;
    while (head) {
        if (head->value > max) max = head->value;
        head = head->next;
    }
    return max;
}

int test_main(void) {
    test_printstr("Testing data structures...\n");
    
    // Build list using local variables: 5 -> 10 -> 15 -> 20
    struct Node n4 = {20, 0};
    struct Node n3 = {15, &n4};
    struct Node n2 = {10, &n3};
    struct Node n1 = {5, &n2};
    
    // Test 1: List sum
    int sum = list_sum(&n1);
    test_printstr("  sum: ");
    test_printint(sum);
    TEST_ASSERT(sum == 50);
    
    // Test 2: List max
    int max = list_max(&n1);
    test_printstr("\n  max: ");
    test_printint(max);
    TEST_ASSERT(max == 20);
    
    test_printstr("\nAll data structure tests passed!\n");
    test_pass();
    return 0;
}
