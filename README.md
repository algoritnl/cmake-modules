# CMake Modules

## CodeCoverage.cmake

Adds a custom build configuration type named Coverage for instrumenting
the project for `gcov` based coverage reporting.

If built with Clang then GNU `gcov` will not work with the generated `.gcda`
and `.gnco` files. There are two ways to solve this:

- Create a symbolic link named `gcov` for `llvm-cov` that will be found
    via `${PATH}` before GNU `gcov`.

    Rationale: if `llvm-cov` is invoked with a base name of `gcov`, it will
    behave as if the `llvm-cov gcov` command were called.

- Invoke `lcov` with arguments: `--gcov-tool <shell-script>`

    `<shell-script>` must be found (via `${PATH}` or an absolute path) and
    have content similar to:

      #!/bin/sh
      /usr/bin/llvm-cov gcov "$@"

## CustomConfigurationType.cmake

Provides a function to define a custom build configuration type.

    add_custom_configuration_type(
        <configuration>
        [BASED_ON <inherited-configuration>]
        [POSTFIX <postfix>]
        [C_FLAGS <c-flag>...]
        [CXX_FLAGS <cxx-flag>...]
        [LINKER_FLAGS <linker-flag>...]
        [EXE_LINKER_FLAGS <exe-linker_flag>...]
        [MODULE_LINKER_FLAGS <module-linker-flag>...]
        [SHARED_LINKER_FLAGS <shared-linker-flag>...]
        [STATIC_LINKER_FLAGS <static-linker-flag>...]
        )

Example:

    add_custom_configuration_type(
        Coverage
        POSTFIX   _cov
        BASED_ON  Debug
        C_FLAGS   -O0 --coverage
        CXX_FLAGS -O0 --coverage
        EXE_LINKER_FLAGS    --coverage
        SHARED_LINKER_FLAGS --coverage)

This will allow single configuration generators (like "Unix Makefiles" and
Ninja) to generate a build system for coverage instrumentation:

    cmake -S <source-dir> -B <build-dir> -DCMAKE_BUILD_TYPE=Coverage

This will work because the necessary CMake variables are created, such as:

    CMAKE_C_FLAGS_COVERAGE="-g -O0 --coverage"
    CMAKE_CXX_FLAGS_COVERAGE="-g -O0 --coverage"
    CMAKE_EXE_LINKER_FLAGS_COVERAGE="--coverage"
    CMAKE_EXE_SHARED_FLAGS_COVERAGE="--coverage"

Notice that for instance `-g` is inherited from the Debug configuration.

## MultipleChoice.cmake

Provides a function to define a multiple choice configuration option.

    multiple_choice(<variable> <docstring> VALID_VALUES <valid_value>...
                    [DEFAULT <default_value>] [FORCE_ON_INVALID|FATAL_ERROR])
