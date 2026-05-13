// Simple Heap Test
// Tests: Binary heap operations
#include "test_syscall.h"

#define MAX_SIZE 50

static int heap[MAX_SIZE];
static int heap_size = 0;

void heap_init(void) {
    heap_size = 0;
}

void heap_swap(int *a, int *b) {
    int t = *a;
    *a = *b;
    *b = t;
}

void heap_push(int val) {
    if (heap_size >= MAX_SIZE) return;
    
    int i = heap_size++;
    heap[i] = val;
    
    // Bubble up
    while (i > 0) {
        int parent = (i - 1) / 2;
        if (heap[parent] <= heap[i]) break;
        heap_swap(&heap[parent], &heap[i]);
        i = parent;
    }
}

int heap_pop(void) {
    if (heap_size == 0) return -1;
    
    int result = heap[0];
    heap[0] = heap[--heap_size];
    
    // Bubble down
    int i = 0;
    while (1) {
        int left = 2 * i + 1;
        int right = 2 * i + 2;
        int smallest = i;
        
        if (left < heap_size && heap[left] < heap[smallest]) {
            smallest = left;
        }
        if (right < heap_size && heap[right] < heap[smallest]) {
            smallest = right;
        }
        
        if (smallest == i) break;
        
        heap_swap(&heap[i], &heap[smallest]);
        i = smallest;
    }
    
    return result;
}

int heap_empty(void) {
    return heap_size == 0;
}

int test_main(void) {
    test_printstr("Testing Heap...\n");
    
    // Test 1: Push and pop
    heap_init();
    heap_push(5);
    heap_push(3);
    heap_push(7);
    
    test_printstr("  push_pop: ");
    int min1 = heap_pop();
    TEST_ASSERT(min1 == 3);
    min1 = heap_pop();
    TEST_ASSERT(min1 == 5);
    min1 = heap_pop();
    TEST_ASSERT(min1 == 7);
    test_printstr("OK\n");
    
    // Test 2: Insertion order independence
    heap_init();
    heap_push(9);
    heap_push(1);
    heap_push(8);
    heap_push(2);
    heap_push(7);
    heap_push(3);
    
    test_printstr("  order: ");
    int prev = heap_pop();
    int sorted = 1;
    while (!heap_empty()) {
        int curr = heap_pop();
        if (curr < prev) sorted = 0;
        prev = curr;
    }
    TEST_ASSERT(sorted);
    test_printstr("OK\n");
    
    // Test 3: Duplicate values
    heap_init();
    heap_push(5);
    heap_push(5);
    heap_push(5);
    
    test_printstr("  dup: ");
    TEST_ASSERT(heap_pop() == 5);
    TEST_ASSERT(heap_pop() == 5);
    TEST_ASSERT(heap_pop() == 5);
    test_printstr("OK\n");
    
    // Test 4: Single element
    heap_init();
    heap_push(42);
    
    test_printstr("  single: ");
    TEST_ASSERT(heap_pop() == 42);
    TEST_ASSERT(heap_empty());
    test_printstr("OK\n");
    
    // Test 5: Many elements
    heap_init();
    for (int i = 20; i >= 1; i--) {
        heap_push(i);
    }
    
    test_printstr("  many: ");
    TEST_ASSERT(heap_pop() == 1);
    TEST_ASSERT(heap_pop() == 2);
    TEST_ASSERT(heap_pop() == 3);
    
    // Pop rest
    while (!heap_empty()) heap_pop();
    test_printstr("OK\n");
    
    test_printstr("All Heap tests passed!\n");
    test_pass();
    return 0;
}
