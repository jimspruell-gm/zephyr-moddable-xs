#if defined(__has_include)
#if __has_include("xs.h") && __has_include("xsmc.h")
#define HAVE_MODDABLE_XS 1
#endif
#endif

#ifdef HAVE_MODDABLE_XS
#include "xs.h"
#include "xsmc.h"

void xs_user_hello(xsMachine *the)
{
    (void)the;
    xsmcSetString(xsResult, "hello from user native C");
}

void xs_user_native_init(void)
{
    xsmcDefine(xsGlobal, xsID("userHello"), xsFunction(xs_user_hello, 0), xsDefault, xsDontDelete | xsDontSet);
}
#else
void xs_user_native_init(void)
{
}
#endif
