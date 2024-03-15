set(BUILD_TARGET firmware_${CMAKE_BUILD_TYPE} CACHE STRING "")

add_executable(${BUILD_TARGET}
    main.c
)

target_link_libraries(${BUILD_TARGET} PRIVATE
    stm32f1xx_hal_driver
    freertos_kernel
)

target_compile_options(${BUILD_TARGET} PRIVATE
    -Wall
    -Wextra
)

target_link_options(${BUILD_TARGET} PRIVATE
    -T${LINKER_FILE}
    --specs=nosys.specs
    --specs=nano.specs
    --specs=rdimon.specs
    -lrdimon
    -Wl,-Map=output.map,--cref
    -Wl,--print-memory-usage
)

add_custom_target(flash
    COMMAND openocd -f ${OPENOCD_CFG_FILE} -c "setup" -c "program_release ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${BUILD_TARGET}.elf"
    DEPENDS ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${BUILD_TARGET}.elf
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)
