void xs_user_native_init(void);
void ti_cc1352p1_drivers_init(void);

void main(void)
{
    ti_cc1352p1_drivers_init();
    xs_user_native_init();
}
