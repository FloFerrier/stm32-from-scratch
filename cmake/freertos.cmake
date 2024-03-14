include(FetchContent)

set(FREERTOS_HEAP 4 CACHE STRING "")
set(FREERTOS_PORT GCC_ARM_CM3 CACHE STRING "")

FetchContent_Declare(
    freertos_kernel
    GIT_REPOSITORY https://github.com/FreeRTOS/FreeRTOS-Kernel.git
    GIT_TAG V10.5.1
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/rtos/FreeRTOS
)

FetchContent_MakeAvailable(freertos_kernel)