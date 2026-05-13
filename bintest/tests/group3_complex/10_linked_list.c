// Test linked list operations
#include "test_syscall.h"

struct Node {
    int value;
    struct Node* next;
};

static struct Node nodes[10];
static int node_count = 0;

struct Node* create_node(int val) {
    if (node_count >= 10) return 0;
    nodes[node_count].value = val;
    nodes[node_count].next = 0;
    return &nodes[node_count++];
}

struct Node* list_append(struct Node* head, int val) {
    struct Node* new_node = create_node(val);
    if (!head) return new_node;
    
    struct Node* curr = head;
    while (curr->next) {
        curr = curr->next;
    }
    curr->next = new_node;
    return head;
}

int list_length(struct Node* head) {
    int count = 0;
    while (head) {
        count++;
        head = head->next;
    }
    return count;
}

int list_sum(struct Node* head) {
    int sum = 0;
    while (head) {
        sum += head->value;
        head = head->next;
    }
    return sum;
}

struct Node* list_reverse(struct Node* head) {
    struct Node* prev = 0;
    struct Node* curr = head;
    while (curr) {
        struct Node* next = curr->next;
        curr->next = prev;
        prev = curr;
        curr = next;
    }
    return prev;
}

int list_find(struct Node* head, int val) {
    int index = 0;
    while (head) {
        if (head->value == val) return index;
        head = head->next;
        index++;
    }
    return -1;
}

int test_main(void) {
    test_printstr("Testing linked list...\n");
    
    // Test 1: Create and append
    struct Node* list = 0;
    list = list_append(list, 10);
    list = list_append(list, 20);
    list = list_append(list, 30);
    int len = list_length(list);
    test_printstr("  length: ");
    test_printint(len);
    TEST_ASSERT(len == 3);
    
    // Test 2: List sum
    int sum = list_sum(list);
    test_printstr("\n  sum: ");
    test_printint(sum);
    TEST_ASSERT(sum == 60);
    
    // Test 3: Find element
    int idx = list_find(list, 20);
    test_printstr("\n  find(20): index ");
    test_printint(idx);
    TEST_ASSERT(idx == 1);
    
    idx = list_find(list, 99);
    test_printstr("\n  find(99): index ");
    test_printint(idx);
    TEST_ASSERT(idx == -1);
    
    // Test 4: Reverse list
    list = list_reverse(list);
    idx = list_find(list, 10);  // Was first, now last
    test_printstr("\n  after reverse, find(10): index ");
    test_printint(idx);
    TEST_ASSERT(idx == 2);
    
    // Test 5: First element after reverse
    test_printstr("\n  first after reverse: ");
    test_printint(list->value);
    TEST_ASSERT(list->value == 30);
    
    test_printstr("\nAll linked list tests passed!\n");
    test_pass();
    return 0;
}
