#include <zephyr/kernel.h>

void xs_user_native_init(void);
void ti_cc1352p1_drivers_init(void);

void main(void)
{
    ti_cc1352p1_drivers_init();
    xs_user_native_init();

    while (1) {
        k_sleep(K_SECONDS(1));
    }
}
