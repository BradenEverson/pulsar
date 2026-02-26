//! Time logging utilites

const c = @cImport({
    @cDefine("USE_HAL_DRIVER", {});
    @cDefine("STM32F446xx", {});
    @cInclude("main.h");
});

extern var htim5: c.TIM_HandleTypeDef;

pub inline fn getTimeMicros() u32 {
    return c.__HAL_TIM_GET_COUNTER(&htim5);
}
