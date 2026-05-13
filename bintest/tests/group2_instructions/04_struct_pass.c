// Test struct passing
#include "test_syscall.h"

struct Point {
    int x;
    int y;
};

int point_sum(struct Point p) {
    return p.x + p.y;
}

struct Point make_point(int x, int y) {
    struct Point p = {x, y};
    return p;
}

int test_main(void) {
    test_printstr("Testing struct passing...\n");
    
    struct Point p1 = {10, 20};
    int sum = point_sum(p1);
    test_printstr("  point_sum: ");
    test_printint(sum);
    TEST_ASSERT(sum == 30);
    
    struct Point p2 = make_point(5, 7);
    test_printstr("\n  make_point: ");
    test_printint(p2.x);
    test_printstr(", ");
    test_printint(p2.y);
    TEST_ASSERT(p2.x == 5 && p2.y == 7);
    
    test_printstr("\nAll struct tests passed!\n");
    test_pass();
    return 0;
}