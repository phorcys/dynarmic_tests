// Union-Find (Disjoint Set) Test
// Tests: Union-Find with path compression and union by rank
#include "test_syscall.h"

#define MAX_ELEMENTS 100

static int parent[MAX_ELEMENTS];
static int rank[MAX_ELEMENTS];

void uf_init(int n) {
    for (int i = 0; i < n; i++) {
        parent[i] = i;
        rank[i] = 0;
    }
}

int uf_find(int x) {
    if (parent[x] != x) {
        parent[x] = uf_find(parent[x]);  // Path compression
    }
    return parent[x];
}

void uf_union(int x, int y) {
    int px = uf_find(x);
    int py = uf_find(y);
    
    if (px == py) return;
    
    // Union by rank
    if (rank[px] < rank[py]) {
        parent[px] = py;
    } else if (rank[px] > rank[py]) {
        parent[py] = px;
    } else {
        parent[py] = px;
        rank[px]++;
    }
}

int uf_connected(int x, int y) {
    return uf_find(x) == uf_find(y);
}

int test_main(void) {
    test_printstr("Testing Union-Find...\n");
    
    // Test 1: Basic operations
    uf_init(10);
    
    uf_union(0, 1);
    uf_union(2, 3);
    
    test_printstr("  basic: ");
    TEST_ASSERT(uf_connected(0, 1));
    TEST_ASSERT(uf_connected(2, 3));
    TEST_ASSERT(!uf_connected(0, 2));
    test_printstr("OK\n");
    
    // Test 2: Transitive connectivity
    uf_union(1, 2);
    test_printstr("  trans: ");
    TEST_ASSERT(uf_connected(0, 3));  // 0-1-2-3
    TEST_ASSERT(uf_connected(1, 3));
    test_printstr("OK\n");
    
    // Test 3: Multiple components
    uf_init(10);
    uf_union(0, 1);
    uf_union(1, 2);
    uf_union(3, 4);
    uf_union(5, 6);
    uf_union(6, 7);
    
    test_printstr("  comps: ");
    TEST_ASSERT(uf_connected(0, 2));
    TEST_ASSERT(uf_connected(3, 4));
    TEST_ASSERT(uf_connected(5, 7));
    TEST_ASSERT(!uf_connected(0, 3));
    TEST_ASSERT(!uf_connected(2, 5));
    test_printstr("OK\n");
    
    // Test 4: Path compression
    uf_init(10);
    uf_union(0, 1);
    uf_union(0, 2);
    uf_union(0, 3);
    uf_union(0, 4);
    
    test_printstr("  path: ");
    // All should have same root
    int root = uf_find(0);
    TEST_ASSERT(uf_find(1) == root);
    TEST_ASSERT(uf_find(2) == root);
    TEST_ASSERT(uf_find(3) == root);
    TEST_ASSERT(uf_find(4) == root);
    test_printstr("OK\n");
    
    // Test 5: Self union
    uf_init(5);
    uf_union(2, 2);
    test_printstr("  self: ");
    TEST_ASSERT(uf_find(2) == 2);
    test_printstr("OK\n");
    
    // Test 6: Large set
    uf_init(50);
    for (int i = 0; i < 49; i++) {
        uf_union(i, i + 1);
    }
    test_printstr("  large: ");
    TEST_ASSERT(uf_connected(0, 49));
    TEST_ASSERT(uf_connected(25, 26));
    test_printstr("OK\n");
    
    test_printstr("All Union-Find tests passed!\n");
    test_pass();
    return 0;
}
