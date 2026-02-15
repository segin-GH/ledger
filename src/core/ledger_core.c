#include <ledger/ledger.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>

#define LEDGER_MAX_ARGS 4

extern char __executable_start;

int ledger_init(void)
{
    printf("Initializing ledger\n");
    printf("Executable start address: %p\n", &__executable_start);
    return 0;
}

int ledger_deinit(void)
{
    printf("Deinitializing ledger\n");
    return 0;
}

void ledger_record_pc(void *val)
{
    printf("%p\n", val);
}

struct ledger_log_record
{
    uintptr_t pc;
    uintptr_t fmt;
    uint8_t argc;
    uint32_t args[LEDGER_MAX_ARGS];
};

void ledger_log_record(uintptr_t pc, uintptr_t fmt, ...)
{
    struct ledger_log_record rec = {0};
    va_list ap;

    rec.pc = pc;
    rec.fmt = fmt;

    va_start(ap, fmt);

    for (rec.argc = 0; rec.argc < LEDGER_MAX_ARGS; rec.argc++)
    {
        rec.args[rec.argc] = va_arg(ap, uint32_t);
    }

    va_end(ap);

    printf("Log Record - PC: %p, Fmt: %p, Argc: %u, Args: \n", (void *)rec.pc, (void *)rec.fmt, rec.argc);
}
