set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_AR arm-none-eabi-ar${CMAKE_EXECUTABLE_SUFFIX} CACHE INTERNAL "Archiver")
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc${CMAKE_EXECUTABLE_SUFFIX} CACHE INTERNAL "Assembler Compiler")
set(CMAKE_C_COMPILER arm-none-eabi-gcc${CMAKE_EXECUTABLE_SUFFIX} CACHE INTERNAL "C Compiler")
set(CMAKE_CXX_COMPILER arm-none-eabi-g++${CMAKE_EXECUTABLE_SUFFIX} CACHE INTERNAL "C++ Compiler")
set(CMAKE_LINKER arm-none-eabi-ld${CMAKE_EXECUTABLE_SUFFIX} CACHE INTERNAL "Linker")
set(CMAKE_OBJCOPY arm-none-eabi-objcopy${CMAKE_EXECUTABLE_SUFFIX} CACHE INTERNAL "")
set(CMAKE_RANLIB arm-none-eabi-ranlib${CMAKE_EXECUTABLE_SUFFIX} CACHE INTERNAL "")
set(CMAKE_SIZE arm-none-eabi-size${CMAKE_EXECUTABLE_SUFFIX} CACHE INTERNAL "")
set(CMAKE_STRIP arm-none-eabi-strip${CMAKE_EXECUTABLE_SUFFIX} CACHE INTERNAL "")

set(CMAKE_C_FLAGS "-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -nostdlib -fdata-sections -ffunction-sections -Wl,--gc-sections" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -fno-exceptions" CACHE INTERNAL "")

set(CMAKE_C_FLAGS_DEBUG "-Og -g -DDEBUG" CACHE INTERNAL "C Compiler options for debug build type")
set(CMAKE_C_FLAGS_RELEASE "-O2 -DNDEBUG" CACHE INTERNAL "C Compiler options for release build type")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}" CACHE INTERNAL "C++ Compiler options for debug build type")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}" CACHE INTERNAL "C++ Compiler options for release build type")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_EXECUTABLE_SUFFIX_C .elf)
set(CMAKE_EXECUTABLE_SUFFIX_CXX .elf)
set(CMAKE_EXECUTABLE_SUFFIX_ASM .elf)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)