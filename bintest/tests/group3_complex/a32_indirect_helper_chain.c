// A32 infra reproducer:
// multi-helper thunk chain carrying a header base and payload pointer.
#include "test_syscall.h"

typedef unsigned int u32;

struct ChainObject {
    u32 head;
    u32 payload;
    u32 mirror;
    u32 final_value;
};

typedef u32 (*slot_helper)(u32* slot, u32 value);
typedef u32 (*value_helper)(u32 value);

static u32 scratch_page[0x2000] __attribute__((aligned(4096)));

static __attribute__((noinline)) u32 add_to_slot(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 xor_fold(u32 value) {
    return value ^ 0x13579BDFu;
}

static __attribute__((noinline)) u32 round_up_256(u32 value) {
    return (value + 0xFFu) & ~0xFFu;
}

static __attribute__((noinline)) void fill_chain_object(volatile struct ChainObject* obj, u32 payload, u32 final_value) {
    obj->head = 0x12345678u;
    obj->payload = payload;
    obj->mirror = payload ^ 0x00FF00FFu;
    obj->final_value = final_value;
}

int test_main(void) {
    static slot_helper slot_ops[] = {add_to_slot, add_to_slot};
    static value_helper value_ops[] = {xor_fold, round_up_256};

    const u32 base = (u32)(unsigned long)scratch_page;
    u32 slot = base + 0x1881u;

    u32 s1 = slot_ops[0](&slot, 0x40u);
    u32 s2 = slot_ops[1](&slot, 0x3Fu);
    u32 folded = value_ops[0](s2);
    u32 object_base = value_ops[1](slot);
    u32 payload = object_base + 0x100u;

    volatile struct ChainObject* obj = (volatile struct ChainObject*)(unsigned long)object_base;

    fill_chain_object(obj, payload, folded);

    test_printstr("A32 indirect helper chain...\n");
    test_printstr("  object_base: ");
    test_printhex(object_base);
    test_printstr("\n  payload: ");
    test_printhex(payload);
    test_printstr("\n");

    TEST_ASSERT(s1 == base + 0x18C1u);
    TEST_ASSERT(s2 == base + 0x1900u);
    TEST_ASSERT(object_base == base + 0x1900u);
    TEST_ASSERT(payload == base + 0x1A00u);
    TEST_ASSERT(obj->head == 0x12345678u);
    TEST_ASSERT(obj->payload == payload);
    TEST_ASSERT(obj->mirror == (payload ^ 0x00FF00FFu));
    TEST_ASSERT(obj->final_value == folded);

    test_printstr("All indirect helper chain tests passed!\n");
    test_pass();
    return 0;
}
