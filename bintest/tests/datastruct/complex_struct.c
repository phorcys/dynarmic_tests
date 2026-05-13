/*
 * Complex Data Structures Test
 * Tests various data structure implementations
 */

#include "test_syscall.h"

/* Dynamic array-like structure using static storage */
#define MAX_ITEMS 128

typedef struct {
    int64_t data[MAX_ITEMS];
    int64_t size;
    int64_t capacity;
} Vector;

static void vec_init(Vector *v) {
    v->size = 0;
    v->capacity = MAX_ITEMS;
}

static int vec_push(Vector *v, int64_t val) {
    if (v->size >= v->capacity) return -1;
    v->data[v->size++] = val;
    return 0;
}

static int64_t vec_pop(Vector *v) {
    if (v->size <= 0) return -1;
    return v->data[--v->size];
}

static int64_t vec_get(Vector *v, int64_t idx) {
    if (idx < 0 || idx >= v->size) return -1;
    return v->data[idx];
}

static int test_vector(void) {
    test_printstr("Testing vector...\n");
    
    Vector v;
    vec_init(&v);
    
    /* Push elements */
    for (int64_t i = 0; i < 10; i++) {
        TEST_ASSERT(vec_push(&v, i * 10) == 0);
    }
    TEST_ASSERT(v.size == 10);
    
    /* Get elements */
    for (int64_t i = 0; i < 10; i++) {
        TEST_ASSERT(vec_get(&v, i) == i * 10);
    }
    
    /* Pop elements */
    TEST_ASSERT(vec_pop(&v) == 90);
    TEST_ASSERT(vec_pop(&v) == 80);
    TEST_ASSERT(v.size == 8);
    
    test_printstr("  Vector: PASS\n");
    return 0;
}

/* Simple hash map with linear probing */
#define HASH_SIZE 32

typedef struct {
    int64_t key;
    int64_t value;
    int used;
} HashEntry;

typedef struct {
    HashEntry entries[HASH_SIZE];
} HashMap;

static int64_t hash_func(int64_t key) {
    return ((key * 2654435761U) >> 27) % HASH_SIZE;
}

static void hashmap_init(HashMap *m) {
    for (int i = 0; i < HASH_SIZE; i++) {
        m->entries[i].used = 0;
    }
}

static int hashmap_put(HashMap *m, int64_t key, int64_t value) {
    int64_t idx = hash_func(key);
    
    for (int i = 0; i < HASH_SIZE; i++) {
        int64_t try = (idx + i) % HASH_SIZE;
        if (!m->entries[try].used || m->entries[try].key == key) {
            m->entries[try].key = key;
            m->entries[try].value = value;
            m->entries[try].used = 1;
            return 0;
        }
    }
    return -1;  /* Full */
}

static int hashmap_get(HashMap *m, int64_t key, int64_t *value) {
    int64_t idx = hash_func(key);
    
    for (int i = 0; i < HASH_SIZE; i++) {
        int64_t try = (idx + i) % HASH_SIZE;
        if (!m->entries[try].used) return -1;
        if (m->entries[try].key == key) {
            *value = m->entries[try].value;
            return 0;
        }
    }
    return -1;
}

static int test_hashmap(void) {
    test_printstr("Testing hash map...\n");
    
    HashMap m;
    hashmap_init(&m);
    
    /* Insert key-value pairs */
    TEST_ASSERT(hashmap_put(&m, 1, 100) == 0);
    TEST_ASSERT(hashmap_put(&m, 2, 200) == 0);
    TEST_ASSERT(hashmap_put(&m, 33, 3300) == 0);  /* Collision with 1 */
    
    /* Retrieve values */
    int64_t val;
    TEST_ASSERT(hashmap_get(&m, 1, &val) == 0);
    TEST_ASSERT(val == 100);
    
    TEST_ASSERT(hashmap_get(&m, 2, &val) == 0);
    TEST_ASSERT(val == 200);
    
    TEST_ASSERT(hashmap_get(&m, 33, &val) == 0);
    TEST_ASSERT(val == 3300);
    
    /* Non-existent key */
    TEST_ASSERT(hashmap_get(&m, 999, &val) != 0);
    
    test_printstr("  Hash map: PASS\n");
    return 0;
}

/* Simple binary tree */
typedef struct TreeNode {
    int64_t value;
    struct TreeNode *left;
    struct TreeNode *right;
} TreeNode;

static TreeNode node_pool[64];
static int node_count = 0;

static TreeNode *create_node(int64_t value) {
    if (node_count >= 64) return 0;
    TreeNode *n = &node_pool[node_count++];
    n->value = value;
    n->left = 0;
    n->right = 0;
    return n;
}

static void tree_insert(TreeNode **root, int64_t value) {
    if (*root == 0) {
        *root = create_node(value);
        return;
    }
    
    if (value < (*root)->value) {
        tree_insert(&(*root)->left, value);
    } else {
        tree_insert(&(*root)->right, value);
    }
}

static int64_t tree_sum(TreeNode *root) {
    if (root == 0) return 0;
    return root->value + tree_sum(root->left) + tree_sum(root->right);
}

static int64_t tree_depth(TreeNode *root) {
    if (root == 0) return 0;
    int64_t left = tree_depth(root->left);
    int64_t right = tree_depth(root->right);
    return 1 + (left > right ? left : right);
}

static int test_binary_tree(void) {
    test_printstr("Testing binary tree...\n");
    
    node_count = 0;
    TreeNode *root = 0;
    
    /* Insert values */
    tree_insert(&root, 5);
    tree_insert(&root, 3);
    tree_insert(&root, 7);
    tree_insert(&root, 1);
    tree_insert(&root, 9);
    tree_insert(&root, 4);
    tree_insert(&root, 6);
    
    /*      5
         /   \
        3     7
       / \   / \
      1   4 6   9
    */
    
    TEST_ASSERT(tree_sum(root) == 5 + 3 + 7 + 1 + 9 + 4 + 6);
    TEST_ASSERT(tree_depth(root) == 3);
    
    test_printstr("  Binary tree: PASS\n");
    return 0;
}

/* Simple stack */
typedef struct {
    int64_t data[64];
    int top;
} Stack;

static void stack_init(Stack *s) {
    s->top = -1;
}

static int stack_push(Stack *s, int64_t val) {
    if (s->top >= 63) return -1;
    s->data[++s->top] = val;
    return 0;
}

static int stack_pop(Stack *s, int64_t *val) {
    if (s->top < 0) return -1;
    *val = s->data[s->top--];
    return 0;
}

static int stack_empty(Stack *s) {
    return s->top < 0;
}

static int test_stack(void) {
    test_printstr("Testing stack...\n");
    
    Stack s;
    stack_init(&s);
    
    /* Push elements */
    for (int i = 0; i < 5; i++) {
        stack_push(&s, i * 10);
    }
    
    /* Pop and verify LIFO order */
    int64_t val;
    TEST_ASSERT(stack_pop(&s, &val) == 0);
    TEST_ASSERT(val == 40);
    TEST_ASSERT(stack_pop(&s, &val) == 0);
    TEST_ASSERT(val == 30);
    TEST_ASSERT(stack_pop(&s, &val) == 0);
    TEST_ASSERT(val == 20);
    TEST_ASSERT(stack_pop(&s, &val) == 0);
    TEST_ASSERT(val == 10);
    TEST_ASSERT(stack_pop(&s, &val) == 0);
    TEST_ASSERT(val == 0);
    
    TEST_ASSERT(stack_empty(&s));
    
    test_printstr("  Stack: PASS\n");
    return 0;
}

/* Simple queue */
typedef struct {
    int64_t data[64];
    int front;
    int rear;
    int count;
} Queue;

static void queue_init(Queue *q) {
    q->front = 0;
    q->rear = 0;
    q->count = 0;
}

static int queue_enqueue(Queue *q, int64_t val) {
    if (q->count >= 64) return -1;
    q->data[q->rear] = val;
    q->rear = (q->rear + 1) % 64;
    q->count++;
    return 0;
}

static int queue_dequeue(Queue *q, int64_t *val) {
    if (q->count <= 0) return -1;
    *val = q->data[q->front];
    q->front = (q->front + 1) % 64;
    q->count--;
    return 0;
}

static int test_queue(void) {
    test_printstr("Testing queue...\n");
    
    Queue q;
    queue_init(&q);
    
    /* Enqueue elements */
    for (int i = 0; i < 5; i++) {
        queue_enqueue(&q, i * 10);
    }
    
    /* Dequeue and verify FIFO order */
    int64_t val;
    TEST_ASSERT(queue_dequeue(&q, &val) == 0);
    TEST_ASSERT(val == 0);
    TEST_ASSERT(queue_dequeue(&q, &val) == 0);
    TEST_ASSERT(val == 10);
    TEST_ASSERT(queue_dequeue(&q, &val) == 0);
    TEST_ASSERT(val == 20);
    
    test_printstr("  Queue: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Data Structure Tests ===\n");
    
    test_vector();
    test_hashmap();
    test_binary_tree();
    test_stack();
    test_queue();
    
    test_printstr("=== All data structure tests passed ===\n");
    test_pass();
    return 0;
}
