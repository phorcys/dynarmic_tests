function(dynarmic_tests_detect_host_backend)
    if (DYNARMIC_TESTS_EDEN_ROOT)
        list(APPEND CMAKE_MODULE_PATH
            "${DYNARMIC_TESTS_EDEN_ROOT}/externals/cmake-modules"
            "${DYNARMIC_TESTS_EDEN_ROOT}/src/dynarmic/CMakeModules"
        )
    endif()

    include(DetectArchitecture OPTIONAL)

    set(host_arch "${ARCHITECTURE}")
    if (NOT host_arch)
        set(host_arch "${CMAKE_SYSTEM_PROCESSOR}")
    endif()

    set(DYNARMIC_TESTS_HOST_ARCH "${host_arch}" PARENT_SCOPE)
    if (host_arch)
        set(ARCHITECTURE "${host_arch}" CACHE STRING "Host architecture for Dynarmic" FORCE)
        set(ARCHITECTURE "${host_arch}" PARENT_SCOPE)
    endif()
    set(DYNARMIC_TESTS_HOST_BACKEND_AVAILABLE OFF PARENT_SCOPE)
    if ("${host_arch}" STREQUAL "x86_64"
        OR "${host_arch}" STREQUAL "arm64"
        OR "${host_arch}" STREQUAL "riscv64"
        OR "${host_arch}" STREQUAL "loongarch64")
        set(DYNARMIC_TESTS_HOST_BACKEND_AVAILABLE ON PARENT_SCOPE)
    endif()
endfunction()

function(dynarmic_tests_import_dynarmic)
    if (TARGET dynarmic)
        return()
    endif()

    if (NOT DYNARMIC_TESTS_HOST_BACKEND_AVAILABLE)
        return()
    endif()

    if (DYNARMIC_TESTS_EDEN_ROOT)
        set(dynarmic_root "${DYNARMIC_TESTS_EDEN_ROOT}/src/dynarmic")
    elseif (DYNARMIC_TESTS_DYNARMIC_ROOT)
        set(dynarmic_root "${DYNARMIC_TESTS_DYNARMIC_ROOT}")
    elseif (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../src/dynarmic/CMakeLists.txt")
        get_filename_component(dynarmic_root "${CMAKE_CURRENT_SOURCE_DIR}/../../src/dynarmic" ABSOLUTE)
    else()
        set(dynarmic_root "")
    endif()

    if (dynarmic_root AND EXISTS "${dynarmic_root}/CMakeLists.txt")
        include(CMakeDependentOption)
        dynarmic_tests_import_eden_deps()
        set(DYNARMIC_TESTS OFF CACHE BOOL "Build Dynarmic's own tests" FORCE)
        add_subdirectory("${dynarmic_root}" "${CMAKE_BINARY_DIR}/dynarmic")
        if (TARGET dynarmic AND DYNARMIC_TESTS_HOST_ARCH)
            target_compile_definitions(dynarmic PRIVATE "ARCHITECTURE_${DYNARMIC_TESTS_HOST_ARCH}=1")
        endif()
        if (TARGET dynarmic AND xbyak_SOURCE_DIR)
            target_include_directories(dynarmic PRIVATE "${xbyak_SOURCE_DIR}")
        endif()
        return()
    endif()

    find_package(dynarmic CONFIG REQUIRED)
    if (TARGET dynarmic::dynarmic AND NOT TARGET dynarmic)
        add_library(dynarmic ALIAS dynarmic::dynarmic)
    endif()
endfunction()

function(dynarmic_tests_import_eden_deps)
    if (NOT DYNARMIC_TESTS_USE_EDEN_CPM OR NOT DYNARMIC_TESTS_EDEN_ROOT)
        return()
    endif()

    list(APPEND CMAKE_MODULE_PATH
        "${DYNARMIC_TESTS_EDEN_ROOT}/CMakeModules"
        "${DYNARMIC_TESTS_EDEN_ROOT}/externals/cmake-modules"
    )

    include(CPMUtil)

    if (DYNARMIC_TESTS_BOOST_INCLUDE_DIR AND NOT TARGET Boost::headers)
        add_library(Boost::headers INTERFACE IMPORTED)
        target_include_directories(Boost::headers INTERFACE "${DYNARMIC_TESTS_BOOST_INCLUDE_DIR}")
        set(Boost_FOUND TRUE CACHE BOOL "" FORCE)
        set(Boost_INCLUDE_DIR "${DYNARMIC_TESTS_BOOST_INCLUDE_DIR}" CACHE PATH "" FORCE)
        set(Boost_NO_HEADERS FALSE CACHE BOOL "" FORCE)
        set(BOOST_NO_HEADERS FALSE CACHE BOOL "" FORCE)
    endif()

    set(old_cpmfile "${CPMUTIL_JSON_FILE}")
    set(CPMUTIL_JSON_FILE "${DYNARMIC_TESTS_EDEN_ROOT}/cpmfile.json")
    file(READ "${CPMUTIL_JSON_FILE}" CPMFILE_CONTENT)
    if (NOT TARGET Boost::headers)
        AddJsonPackage(boost)
    endif()
    AddJsonPackage(fmt)

    CPMAddPackage(
        NAME unordered_dense
        GITHUB_REPOSITORY martinus/unordered_dense
        GIT_TAG 7b55cab841
        EXCLUDE_FROM_ALL ON
    )

    if (NOT TARGET common)
        add_library(common STATIC
            "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../runners/eden_common_shim.cpp"
        )
        target_include_directories(common PUBLIC
            "${DYNARMIC_TESTS_EDEN_ROOT}/src"
        )
        target_link_libraries(common PUBLIC fmt::fmt)
        target_compile_features(common PUBLIC cxx_std_20)
    endif()

    if ("${DYNARMIC_TESTS_HOST_ARCH}" STREQUAL "x86_64" OR ARCHITECTURE_x86_64)
        set(CPMUTIL_JSON_FILE "${DYNARMIC_TESTS_EDEN_ROOT}/externals/cpmfile.json")
        file(READ "${CPMUTIL_JSON_FILE}" CPMFILE_CONTENT)
        AddJsonPackage(xbyak)
        if (xbyak_SOURCE_DIR AND NOT TARGET xbyak::xbyak)
            add_library(xbyak::xbyak INTERFACE IMPORTED)
            target_include_directories(xbyak::xbyak INTERFACE "${xbyak_SOURCE_DIR}")
        endif()
    endif()

    if ("${DYNARMIC_TESTS_HOST_ARCH}" STREQUAL "arm64" OR ARCHITECTURE_arm64)
        set(CPMUTIL_JSON_FILE "${DYNARMIC_TESTS_EDEN_ROOT}/externals/cpmfile.json")
        file(READ "${CPMUTIL_JSON_FILE}" CPMFILE_CONTENT)
        AddJsonPackage(oaknut)
    endif()

    if ("${DYNARMIC_TESTS_HOST_ARCH}" STREQUAL "riscv64" OR ARCHITECTURE_riscv64)
        set(CPMUTIL_JSON_FILE "${DYNARMIC_TESTS_EDEN_ROOT}/externals/cpmfile.json")
        file(READ "${CPMUTIL_JSON_FILE}" CPMFILE_CONTENT)
        AddJsonPackage(biscuit)
    endif()

    if ("${DYNARMIC_TESTS_HOST_ARCH}" STREQUAL "loongarch64" OR ARCHITECTURE_loongarch64)
        set(CPMUTIL_JSON_FILE "${DYNARMIC_TESTS_EDEN_ROOT}/externals/cpmfile.json")
        file(READ "${CPMUTIL_JSON_FILE}" CPMFILE_CONTENT)
        AddJsonPackage(lagoon)
    endif()

    set(CPMUTIL_JSON_FILE "${old_cpmfile}")
endfunction()
