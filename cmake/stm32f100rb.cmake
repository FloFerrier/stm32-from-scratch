include(FetchContent)

set(CPU cortex-m3 CACHE STRING "")
set(FLOAT_ABI soft CACHE STRING "")
set(OPENOCD_TARGET_BOARD stm32f1x CACHE STRING "")
set(SPECIFIC_BOARD_HAL STM32F100xB CACHE STRING "")

FetchContent_Declare(
  STM32_HAL_Driver
  GIT_REPOSITORY https://github.com/STMicroelectronics/stm32f1xx_hal_driver.git
  GIT_TAG v1.1.9
  SOURCE_DIR ${CMAKE_SOURCE_DIR}/hal/STM32_HAL_Driver
)

FetchContent_MakeAvailable(STM32_HAL_Driver)

FetchContent_Declare(
  STM32_CMSIS_Device
  GIT_REPOSITORY https://github.com/STMicroelectronics/cmsis_device_f1.git
  GIT_TAG v4.3.4
  SOURCE_DIR ${CMAKE_SOURCE_DIR}/hal/CMSIS/Device
)

FetchContent_MakeAvailable(STM32_CMSIS_Device)