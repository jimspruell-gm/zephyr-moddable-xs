#include "cc1352p1.h"

#if defined(__has_include)
#if __has_include(<ti/drivers/GPIO.h>)
#define HAVE_TI_SIMPLELINK_DRIVERS 1
#endif
#endif

#ifdef HAVE_TI_SIMPLELINK_DRIVERS
#include <ti/drivers/GPIO.h>
#endif

static bool g_ti_drivers_ready;

void ti_cc1352p1_drivers_init(void)
{
#ifdef HAVE_TI_SIMPLELINK_DRIVERS
    GPIO_init();
    g_ti_drivers_ready = true;
#else
    g_ti_drivers_ready = false;
#endif
}

bool ti_cc1352p1_drivers_ready(void)
{
    return g_ti_drivers_ready;
}
