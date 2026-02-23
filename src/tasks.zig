//! Generic tasks to register

const c = @cImport({
    @cDefine("USE_HAL_DRIVER", {});
    @cDefine("STM32F446xx", {});
    @cInclude("main.h");
});

pub fn foo() noreturn {
    while (true) {
        c.HAL_GPIO_WritePin(c.LD2_GPIO_Port, c.LD2_Pin, c.GPIO_PIN_SET);
    }
}

pub fn bar() noreturn {
    while (true) {
        c.HAL_GPIO_WritePin(c.LD2_GPIO_Port, c.LD2_Pin, c.GPIO_PIN_RESET);
    }
}
