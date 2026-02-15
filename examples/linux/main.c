#include <ledger/ledger.h>
#include <stdio.h>

int func1(void)
{
    LEDGER_LOGI("This a 1 msg: %u\n", 1);
    LEDGER_TRACE();
    return 0;
}

int func2(void)
{
    LEDGER_LOGI("This a 2 msg: %u\n", 2);
    LEDGER_TRACE();
    return 0;
}

int main(void)
{
    ledger_init();

    func1();

    func2();

    ledger_deinit();
}
