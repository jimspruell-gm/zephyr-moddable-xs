#if defined(__has_include)
#if __has_include(<ti/drivers/GPIO.h>)
#define HAVE_TI_SIMPLELINK_DRIVERS 1
#endif
#endif

#ifdef HAVE_TI_SIMPLELINK_DRIVERS
#include <ti/drivers/GPIO.h>
#endif

void ti_cc1352p1_drivers_init(void)
{
#ifdef HAVE_TI_SIMPLELINK_DRIVERS
    GPIO_init();
#endif
}
