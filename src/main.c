#include "cc1352p1.h"

void xs_user_native_init(void);

int main(void)
{
    ti_cc1352p1_drivers_init();
    xs_user_native_init();
    return 0;
}
