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
    xsmcSetString(xsResult, "hello from user native C");
}

void xs_user_native_init(void)
{
}
#else
void xs_user_native_init(void)
{
}
#endif
