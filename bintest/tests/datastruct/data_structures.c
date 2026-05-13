/*
 * Complex Data Structures Test
 * Tests various data structure implementations
 */

#include "test_syscall.h"

/* Simple binary tree node */
typedef struct TreeNode {
    int64_t value;
    struct TreeNode *left;
    struct TreeNode *right;
} TreeNode;

/* Static tree node pool */
static TreeNode node_pool[100];
static int node_count = 0;

static TreeNode *alloc_node(void) {
    if (node_count >= 100) return 0;
    TreeNode *n = &node_pool[node_count++];
    n->left = 0;
    n->right = 0;
    return n;
}

/* Insert into BST */
static TreeNode *bst_insert(TreeNode *root, int64_t value) {
    if (root == 0) {
        TreeNode *n = alloc_node();
        if (n == 0) return 0;
        n->value = value;
        return n;
    }
    
    if (value < root->value) {
        root->left = bst_insert(root->left, value);
    } else if (value > root->value) {
        root->right = bst_insert(root->right, value);
    }
    
    return root;
}

/* Search BST */
static TreeNode *bst_search(TreeNode *root, int64_t value) {
    if (root == 0) return 0;
    if (value == root->value) return root;
    if (value < root->value) return bst_search(root->left, value);
    return bst_search(root->right, value);
}

/* Count nodes */
static int bst_count(TreeNode *root) {
    if (root == 0) return 0;
    return 1 + bst_count(root->left) + bst_count(root->right);
}

/* Tree height */
static int bst_height(TreeNode *root) {
    if (root == 0) return 0;
    int lh = bst_height(root->left);
    int rh = bst_height(root->right);
    return 1 + (lh > rh ? lh : rh);
}

/* Simple hash table */
#define HASH_SIZE 16

typedef struct HashEntry {
    int64_t key;
    int64_t value;
    int used;
} HashEntry;

static HashEntry hash_table[HASH_SIZE];

static int hash_func(int64_t key) {
    return (int)(key % HASH_SIZE);
}

static void hash_insert(int64_t key, int64_t value) {
    int idx = hash_func(key);
    int start = idx;
    
    while (hash_table[idx].used) {
        if (hash_table[idx].key == key) {
            hash_table[idx].value = value;
            return;
        }
        idx = (idx + 1) % HASH_SIZE;
        if (idx == start) return;  /* Table full */
    }
    
    hash_table[idx].key = key;
    hash_table[idx].value = value;
    hash_table[idx].used = 1;
}

static int hash_lookup(int64_t key, int64_t *value) {
    int idx = hash_func(key);
    int start = idx;
    
    while (hash_table[idx].used) {
        if (hash_table[idx].key == key) {
            *value = hash_table[idx].value;
            return 1;
        }
        idx = (idx + 1) % HASH_SIZE;
        if (idx == start) break;
    }
    
    return 0;
}

/* Simple stack */
#define STACK_SIZE 32

static int64_t stack_data[STACK_SIZE];
static int stack_top = 0;

static void stack_push(int64_t val) {
    if (stack_top < STACK_SIZE) {
        stack_data[stack_top++] = val;
    }
}

static int stack_pop(int64_t *val) {
    if (stack_top > 0) {
        *val = stack_data[--stack_top];
        return 1;
    }
    return 0;
}

/* Simple queue */
#define QUEUE_SIZE 32

static int64_t queue_data[QUEUE_SIZE];
static int queue_head = 0;
static int queue_tail = 0;

static void queue_enqueue(int64_t val) {
    int next = (queue_tail + 1) % QUEUE_SIZE;
    if (next != queue_head) {
        queue_data[queue_tail] = val;
        queue_tail = next;
    }
}

static int queue_dequeue(int64_t *val) {
    if (queue_head != queue_tail) {
        *val = queue_data[queue_head];
        queue_head = (queue_head + 1) % QUEUE_SIZE;
        return 1;
    }
    return 0;
}

/* Test BST */
static int test_bst(void) {
    test_printstr("Testing BST...\n");
    
    node_count = 0;
    TreeNode *root = 0;
    
    root = bst_insert(root, 50);
    bst_insert(root, 30);
    bst_insert(root, 70);
    bst_insert(root, 20);
    bst_insert(root, 40);
    
    TEST_ASSERT(bst_count(root) == 5);
    
    TreeNode *found = bst_search(root, 30);
    TEST_ASSERT(found != 0 && found->value == 30);
    
    found = bst_search(root, 100);
    TEST_ASSERT(found == 0);
    
    test_printstr("  BST: PASS\n");
    return 0;
}

/* Test hash table */
static int test_hash_table(void) {
    test_printstr("Testing hash table...\n");
    
    /* Clear table */
    for (int i = 0; i < HASH_SIZE; i++) {
        hash_table[i].used = 0;
    }
    
    hash_insert(1, 100);
    hash_insert(2, 200);
    hash_insert(17, 300);  /* Same bucket as 1 */
    
    int64_t val;
    TEST_ASSERT(hash_lookup(1, &val) && val == 100);
    TEST_ASSERT(hash_lookup(2, &val) && val == 200);
    TEST_ASSERT(hash_lookup(17, &val) && val == 300);
    TEST_ASSERT(!hash_lookup(99, &val));
    
    /* Update existing */
    hash_insert(1, 150);
    TEST_ASSERT(hash_lookup(1, &val) && val == 150);
    
    test_printstr("  Hash table: PASS\n");
    return 0;
}

/* Test stack */
static int test_stack(void) {
    test_printstr("Testing stack...\n");
    
    stack_top = 0;
    
    stack_push(1);
    stack_push(2);
    stack_push(3);
    
    int64_t val;
    TEST_ASSERT(stack_pop(&val) && val == 3);
    TEST_ASSERT(stack_pop(&val) && val == 2);
    TEST_ASSERT(stack_pop(&val) && val == 1);
    TEST_ASSERT(!stack_pop(&val));  /* Empty */
    
    test_printstr("  Stack: PASS\n");
    return 0;
}

/* Test queue */
static int test_queue(void) {
    test_printstr("Testing queue...\n");
    
    queue_head = queue_tail = 0;
    
    queue_enqueue(1);
    queue_enqueue(2);
    queue_enqueue(3);
    
    int64_t val;
    TEST_ASSERT(queue_dequeue(&val) && val == 1);
    TEST_ASSERT(queue_dequeue(&val) && val == 2);
    TEST_ASSERT(queue_dequeue(&val) && val == 3);
    TEST_ASSERT(!queue_dequeue(&val));  /* Empty */
    
    test_printstr("  Queue: PASS\n");
    return 0;
}

/* Test linked list via tree nodes */
static int test_linked_list(void) {
    test_printstr("Testing linked list...\n");
    
    node_count = 0;
    
    /* Create a simple linked list using tree nodes */
    TreeNode *head = alloc_node();
    head->value = 1;
    
    TreeNode *second = alloc_node();
    second->value = 2;
    head->right = second;
    
    TreeNode *third = alloc_node();
    third->value = 3;
    second->right = third;
    
    /* Traverse and sum */
    int64_t sum = 0;
    TreeNode *curr = head;
    while (curr != 0) {
        sum += curr->value;
        curr = curr->right;
    }
    
    TEST_ASSERT(sum == 6);
    
    test_printstr("  Linked list: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Data Structure Tests ===\n");
    
    test_bst();
    test_hash_table();
    test_stack();
    test_queue();
    test_linked_list();
    
    test_printstr("All data structure tests passed!\n");
    test_pass();
    return 0;
}
