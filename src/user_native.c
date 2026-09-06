#if defined(__has_include)
#if __has_include("xs.h") && __has_include("xsmc.h")
#define HAVE_MODDABLE_XS 1
#endif
#endif

#ifdef HAVE_MODDABLE_XS
#include "xs.h"
#include "xsmc.h"
#include "drivers/cc1352p1.h"

void xs_user_hello(xsMachine *the)
{
    (void)the;
    xsmcSetString(xsResult, "hello from user native C");
}

void xs_board_drivers_ready(xsMachine *the)
{
    (void)the;
    xsmcSetBoolean(xsResult, ti_cc1352p1_drivers_ready());
}

void xs_user_native_init(void)
{
    xsmcDefine(xsGlobal, xsID("userHello"), xsFunction(xs_user_hello, 0), xsDefault, xsDontDelete | xsDontSet);
    xsmcDefine(xsGlobal, xsID("boardDriversReady"), xsFunction(xs_board_drivers_ready, 0), xsDefault, xsDontDelete | xsDontSet);
}
#else
void xs_user_native_init(void)
{
}
#endif
