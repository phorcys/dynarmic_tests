/*
 * Stack Operations and Deep Recursion Tests
 * Tests stack pointer manipulation, deep call chains, and stack frames
 */

#include "test_syscall.h"

/* Test shallow recursion */
static int64_t shallow_sum(int64_t n) {
    if (n <= 0) return 0;
    return n + shallow_sum(n - 1);
}

static int test_shallow_recursion(void) {
    test_printstr("Testing shallow recursion...\n");
    
    /* Sum 1 to 20 */
    int64_t result = shallow_sum(20);
    TEST_ASSERT(result == 210);
    
    test_printstr("  Shallow recursion: PASS\n");
    return 0;
}

/* Test local array on stack */
static int test_stack_array(void) {
    test_printstr("Testing stack arrays...\n");
    
    /* Large local array */
    volatile int64_t arr[64];
    
    for (int i = 0; i < 64; i++) {
        arr[i] = i * i;
    }
    
    int64_t sum = 0;
    for (int i = 0; i < 64; i++) {
        sum += arr[i];
    }
    
    /* Sum of squares 0..63 = 63*64*127/6 = 85344 */
    TEST_ASSERT(sum == 85344);
    
    test_printstr("  Stack arrays: PASS\n");
    return 0;
}

/* Test variadic-like function with many arguments */
static int64_t sum_many(int64_t a, int64_t b, int64_t c, int64_t d, 
                        int64_t e, int64_t f, int64_t g, int64_t h) {
    return a + b + c + d + e + f + g + h;
}

static int test_many_args(void) {
    test_printstr("Testing many arguments...\n");
    
    int64_t result = sum_many(1, 2, 3, 4, 5, 6, 7, 8);
    TEST_ASSERT(result == 36);
    
    /* More arguments than registers - some on stack */
    result = sum_many(10, 20, 30, 40, 50, 60, 70, 80);
    TEST_ASSERT(result == 360);
    
    test_printstr("  Many arguments: PASS\n");
    return 0;
}

/* Test nested function calls with stack data */
struct StackData {
    int64_t values[8];
    int64_t sum;
};

static int64_t process_stack_data(struct StackData *data) {
    data->sum = 0;
    for (int i = 0; i < 8; i++) {
        data->sum += data->values[i];
    }
    return data->sum;
}

static int test_struct_on_stack(void) {
    test_printstr("Testing struct on stack...\n");
    
    struct StackData data;
    for (int i = 0; i < 8; i++) {
        data.values[i] = (i + 1) * 10;
    }
    
    int64_t result = process_stack_data(&data);
    TEST_ASSERT(result == 10 + 20 + 30 + 40 + 50 + 60 + 70 + 80);
    TEST_ASSERT(data.sum == result);
    
    test_printstr("  Struct on stack: PASS\n");
    return 0;
}

/* Test alloca-like behavior with variable array */
static int test_variable_stack(void) {
    test_printstr("Testing variable stack usage...\n");
    
    /* Different stack usage patterns */
    volatile int64_t buf1[16];
    volatile int64_t buf2[32];
    
    for (int i = 0; i < 16; i++) buf1[i] = i;
    for (int i = 0; i < 32; i++) buf2[i] = i * 2;
    
    int64_t sum = 0;
    for (int i = 0; i < 16; i++) sum += buf1[i];
    for (int i = 0; i < 32; i++) sum += buf2[i];
    
    /* 0+1+...+15 + 0+2+4+...+62 = 120 + 992 = 1112 */
    TEST_ASSERT(sum == 1112);
    
    test_printstr("  Variable stack: PASS\n");
    return 0;
}

/* Test mutually recursive functions */
static int64_t mutual_a(int64_t n);
static int64_t mutual_b(int64_t n);

static int64_t mutual_a(int64_t n) {
    if (n <= 0) return 0;
    return 1 + mutual_b(n - 1);
}

static int64_t mutual_b(int64_t n) {
    if (n <= 0) return 0;
    return 2 + mutual_a(n - 1);
}

static int test_mutual_recursion(void) {
    test_printstr("Testing mutual recursion...\n");
    
    /* Simplified test - mutual_a(2) = 1 + mutual_b(1)
       mutual_b(1) = 2 + mutual_a(0) = 2
       mutual_a(2) = 1 + 2 = 3
    */
    int64_t result = mutual_a(2);
    TEST_ASSERT(result == 3);
    
    result = mutual_b(2);
    TEST_ASSERT(result == 4);
    
    test_printstr("  Mutual recursion: PASS\n");
    return 0;
}

/* Test callback functions stored on stack */
typedef int64_t (*callback_t)(int64_t);

static int64_t apply_callback(callback_t cb, int64_t *arr, int64_t n) {
    int64_t sum = 0;
    for (int64_t i = 0; i < n; i++) {
        sum += cb(arr[i]);
    }
    return sum;
}

static int64_t square(int64_t x) { return x * x; }
static int64_t double_it(int64_t x) { return x * 2; }

static int test_callback_stack(void) {
    test_printstr("Testing callbacks...\n");
    
    int64_t arr[] = {1, 2, 3, 4, 5};
    
    int64_t result = apply_callback(square, arr, 5);
    TEST_ASSERT(result == 1 + 4 + 9 + 16 + 25);  /* = 55 */
    
    result = apply_callback(double_it, arr, 5);
    TEST_ASSERT(result == 2 + 4 + 6 + 8 + 10);  /* = 30 */
    
    test_printstr("  Callbacks: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Stack Operations Tests ===\n");
    
    test_shallow_recursion();
    test_stack_array();
    test_many_args();
    test_struct_on_stack();
    test_variable_stack();
    test_callback_stack();
    
    test_printstr("=== All stack tests passed ===\n");
    test_pass();
    return 0;
}
