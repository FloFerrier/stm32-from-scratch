include(${CMAKE_SOURCE_DIR}/cmake/stm32f100rb.cmake)

file(GLOB STM32_HAL_SRC_FILES CONFIGURE_DEPENDS
    stm32f1xx_hal_driver/Src/*.c
    CMSIS/Device/Source/Templates/*.c
    CMSIS/Device/Source/Templates/gcc/startup_stm32f100xb.s
)

add_library(stm32f1xx_hal_driver STATIC ${STM32_HAL_SRC_FILES})

target_include_directories(stm32f1xx_hal_driver PUBLIC
    Inc
    stm32f1xx_hal_driver/Inc
    stm32f1xx_hal_driver/Inc/Legacy
    CMSIS/Device/Include
    CMSIS/Include
)

target_compile_definitions(stm32f1xx_hal_driver PRIVATE
    -DUSE_HAL_DRIVER
)

target_compile_definitions(stm32f1xx_hal_driver PUBLIC
    -D${SPECIFIC_BOARD_HAL}
)