// A32 infra reproducer:
// helper accumulation -> 32-bit align-up -> header/payload object init.
#include "test_syscall.h"

typedef unsigned char u8;
typedef unsigned int u32;

struct Header {
    u32 tag;
    u32 flags;
    u32 self;
    u32 next;
    u32 payload;
    u32 checksum;
    u32 slot_value;
};

typedef u32 (*update_helper)(u32* slot, u32 a, u32 b);
typedef u32 (*read_helper)(const u32* slot);

static u8 arena[0x30000] __attribute__((aligned(4096)));

static __attribute__((noinline)) u32 accumulate_minus_one(u32* slot, u32 a, u32 b) {
    *slot = *slot + a + b - 1u;
    return *slot;
}

static __attribute__((noinline)) u32 read_slot_value(const u32* slot) {
    return *slot;
}

static __attribute__((noinline)) u32 align_up_4k(u32 value) {
    return (value + 0xFFFu) & ~0xFFFu;
}

static __attribute__((noinline)) void initialize_object(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct Header* header = (volatile struct Header*)(unsigned long)header_base;
    volatile u8* payload = (volatile u8*)(unsigned long)payload_base;

    header->tag = 0x00EAA44Cu;
    header->flags = 0x0000000Cu;
    header->self = header_base;
    header->next = header_base + 0x013Cu;
    header->payload = payload_base;
    header->checksum = 0x89ABCDEFu ^ slot_value;
    header->slot_value = slot_value;

    for (u32 i = 0; i < 0x40; i++) {
        payload[i] = (u8)(0x30u + ((slot_value >> (i & 7)) & 0x0Fu));
    }
}

int test_main(void) {
    static update_helper update_table[] = {accumulate_minus_one};
    static read_helper read_table[] = {read_slot_value};

    const u32 arena_base = (u32)(unsigned long)arena;
    u32 slot = arena_base + 0x0FC77u;
    const u32 updated = update_table[0](&slot, 0x00000380u, 0x00000008u);
    const u32 observed = read_table[0](&slot);
    const u32 header_base = align_up_4k(observed);
    const u32 payload_base = header_base + 0x10000u;

    test_printstr("A32 helper/align/object chain...\n");
    test_printstr("  arena_base: ");
    test_printhex(arena_base);
    test_printstr("\n  slot: ");
    test_printhex(slot);
    test_printstr("\n  header_base: ");
    test_printhex(header_base);
    test_printstr("\n  payload_base: ");
    test_printhex(payload_base);
    test_printstr("\n");

    TEST_ASSERT(updated == observed);
    TEST_ASSERT(observed == arena_base + 0x0FFFEu);
    TEST_ASSERT(header_base == arena_base + 0x10000u);
    TEST_ASSERT(payload_base == arena_base + 0x20000u);
    TEST_ASSERT(header_base >= arena_base);
    TEST_ASSERT(payload_base + 0x40u <= arena_base + sizeof(arena));

    initialize_object(header_base, payload_base, observed);

    volatile struct Header* header = (volatile struct Header*)(unsigned long)header_base;
    volatile u8* payload = (volatile u8*)(unsigned long)payload_base;

    TEST_ASSERT(header->tag == 0x00EAA44Cu);
    TEST_ASSERT(header->flags == 0x0000000Cu);
    TEST_ASSERT(header->self == header_base);
    TEST_ASSERT(header->next == header_base + 0x013Cu);
    TEST_ASSERT(header->payload == payload_base);
    TEST_ASSERT(header->checksum == (0x89ABCDEFu ^ observed));
    TEST_ASSERT(header->slot_value == observed);
    TEST_ASSERT(payload[0] == (u8)(0x30u + ((observed >> 0) & 0x0Fu)));
    TEST_ASSERT(payload[7] == (u8)(0x30u + ((observed >> 7) & 0x0Fu)));
    TEST_ASSERT(payload[31] == (u8)(0x30u + ((observed >> 7) & 0x0Fu)));

    test_printstr("All helper/align/object tests passed!\n");
    test_pass();
    return 0;
}
