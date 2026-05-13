// Queue Data Structure Test
// Tests: Queue operations (FIFO)
#include "test_syscall.h"

#define QUEUE_SIZE 50

static int queue[QUEUE_SIZE];
static int q_front = 0;
static int q_rear = 0;
static int q_count = 0;

void queue_init(void) {
    q_front = 0;
    q_rear = 0;
    q_count = 0;
}

int queue_enqueue(int val) {
    if (q_count >= QUEUE_SIZE) return 0;
    queue[q_rear] = val;
    q_rear = (q_rear + 1) % QUEUE_SIZE;
    q_count++;
    return 1;
}

int queue_dequeue(void) {
    if (q_count <= 0) return -1;
    int val = queue[q_front];
    q_front = (q_front + 1) % QUEUE_SIZE;
    q_count--;
    return val;
}

int queue_peek(void) {
    if (q_count <= 0) return -1;
    return queue[q_front];
}

int queue_empty(void) {
    return q_count == 0;
}

int queue_size(void) {
    return q_count;
}

int test_main(void) {
    test_printstr("Testing Queue...\n");
    
    // Test 1: Basic enqueue/dequeue
    queue_init();
    queue_enqueue(1);
    queue_enqueue(2);
    queue_enqueue(3);
    
    test_printstr("  basic: ");
    TEST_ASSERT(queue_dequeue() == 1);
    TEST_ASSERT(queue_dequeue() == 2);
    TEST_ASSERT(queue_dequeue() == 3);
    test_printstr("OK\n");
    
    // Test 2: FIFO order
    queue_init();
    for (int i = 1; i <= 5; i++) {
        queue_enqueue(i);
    }
    
    test_printstr("  fifo: ");
    int correct = 1;
    for (int i = 1; i <= 5; i++) {
        if (queue_dequeue() != i) correct = 0;
    }
    TEST_ASSERT(correct);
    test_printstr("OK\n");
    
    // Test 3: Peek
    queue_init();
    queue_enqueue(10);
    queue_enqueue(20);
    
    test_printstr("  peek: ");
    TEST_ASSERT(queue_peek() == 10);
    TEST_ASSERT(queue_size() == 2);  // Peek doesn't remove
    test_printstr("OK\n");
    
    // Test 4: Empty queue
    queue_init();
    
    test_printstr("  empty: ");
    TEST_ASSERT(queue_empty());
    TEST_ASSERT(queue_dequeue() == -1);
    TEST_ASSERT(queue_peek() == -1);
    test_printstr("OK\n");
    
    // Test 5: Size tracking
    queue_init();
    TEST_ASSERT(queue_size() == 0);
    queue_enqueue(1);
    TEST_ASSERT(queue_size() == 1);
    queue_enqueue(2);
    TEST_ASSERT(queue_size() == 2);
    queue_dequeue();
    TEST_ASSERT(queue_size() == 1);
    test_printstr("  size: OK\n");
    
    // Test 6: Wrap-around
    queue_init();
    for (int i = 0; i < 40; i++) {
        queue_enqueue(i);
    }
    for (int i = 0; i < 40; i++) {
        queue_dequeue();
    }
    
    test_printstr("  wrap: ");
    TEST_ASSERT(queue_empty());
    queue_enqueue(100);
    TEST_ASSERT(queue_dequeue() == 100);
    test_printstr("OK\n");
    
    test_printstr("All Queue tests passed!\n");
    test_pass();
    return 0;
}
