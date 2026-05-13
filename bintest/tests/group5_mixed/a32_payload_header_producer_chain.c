// A32 infra reproducer:
// producer chain -> payload base -> header base (payload - 0x10000) -> object init.
#include "test_syscall.h"

typedef unsigned char u8;
typedef unsigned int u32;

struct ProducerHeader {
    u32 tag;
    u32 header_base;
    u32 payload_base;
    u32 next;
    u32 stamp;
    u32 slot_value;
};

typedef u32 (*slot_stage)(u32* slot, u32 value);
typedef u32 (*value_stage)(u32 value);
typedef void (*build_stage)(u32 header_base, u32 payload_base, u32 slot_value);

static u8 arena[0x50000] __attribute__((aligned(4096)));

static __attribute__((noinline)) u32 stage_add(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 stage_align_payload(u32 value) {
    return (value + 0xFFFu) & ~0xFFFu;
}

static __attribute__((noinline)) u32 stage_header_from_payload(u32 payload_base) {
    return payload_base - 0x10000u;
}

static __attribute__((noinline)) void stage_build(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct ProducerHeader* header = (volatile struct ProducerHeader*)(unsigned long)header_base;
    volatile u8* payload = (volatile u8*)(unsigned long)payload_base;

    header->tag = 0x00EAA44Cu;
    header->header_base = header_base;
    header->payload_base = payload_base;
    header->next = header_base + 0x013Cu;
    header->stamp = payload_base ^ 0x00FF00FFu;
    header->slot_value = slot_value;

    for (u32 i = 0; i < 0x40; i++) {
        payload[i] = (u8)(0x50u + ((slot_value >> (i & 7)) & 0x0Fu));
    }
}

int test_main(void) {
    static slot_stage slot_ops[] = {stage_add, stage_add};
    static value_stage value_ops[] = {stage_align_payload, stage_header_from_payload};
    static build_stage build_ops[] = {stage_build};

    const u32 arena_base = (u32)(unsigned long)arena;
    u32 slot = arena_base + 0x0F877u;
    const u32 s1 = slot_ops[0](&slot, 0x200u);
    const u32 s2 = slot_ops[1](&slot, 0x588u);
    const u32 payload_base = value_ops[0](s2);
    const u32 header_base = value_ops[1](payload_base);

    test_printstr("A32 payload/header producer chain...\n");
    test_printstr("  slot: ");
    test_printhex(slot);
    test_printstr("\n  header_base: ");
    test_printhex(header_base);
    test_printstr("\n  payload_base: ");
    test_printhex(payload_base);
    test_printstr("\n");

    TEST_ASSERT(s1 == arena_base + 0x0FA77u);
    TEST_ASSERT(s2 == arena_base + 0x10000u - 1u);
    TEST_ASSERT(payload_base == arena_base + 0x10000u);
    TEST_ASSERT(header_base == arena_base);
    TEST_ASSERT(payload_base - header_base == 0x10000u);
    TEST_ASSERT(payload_base + 0x40u <= arena_base + sizeof(arena));

    build_ops[0](header_base, payload_base, s2);

    volatile struct ProducerHeader* header = (volatile struct ProducerHeader*)(unsigned long)header_base;
    volatile u8* payload = (volatile u8*)(unsigned long)payload_base;

    TEST_ASSERT(header->tag == 0x00EAA44Cu);
    TEST_ASSERT(header->header_base == header_base);
    TEST_ASSERT(header->payload_base == payload_base);
    TEST_ASSERT(header->next == header_base + 0x013Cu);
    TEST_ASSERT(header->stamp == (payload_base ^ 0x00FF00FFu));
    TEST_ASSERT(header->slot_value == s2);
    TEST_ASSERT(payload[0] == (u8)(0x50u + ((s2 >> 0) & 0x0Fu)));
    TEST_ASSERT(payload[7] == (u8)(0x50u + ((s2 >> 7) & 0x0Fu)));
    TEST_ASSERT(payload[31] == (u8)(0x50u + ((s2 >> 7) & 0x0Fu)));

    test_printstr("All payload/header producer chain tests passed!\n");
    test_pass();
    return 0;
}
