#include <cstdlib>
#include <cstdio>

#include <fmt/format.h>

#include "common/logging.h"

void AssertFailSoftImpl() {
    std::fflush(stderr);
}

[[noreturn]] void AssertFatalImpl() {
    std::fflush(stderr);
    std::abort();
}

namespace Common::Log {

void FmtLogMessageImpl(Class, Level log_level, const char* filename, unsigned int line_num,
                       const char* function, fmt::string_view format,
                       const fmt::format_args& args) {
    const auto message = fmt::vformat(format, args);
    std::fprintf(stderr, "[dynarmic_tests:%u] %s:%u %s: %s\n",
                 static_cast<unsigned>(log_level), filename, line_num, function, message.c_str());
}

} // namespace Common::Log
