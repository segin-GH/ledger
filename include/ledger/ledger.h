#ifndef LEDGER_H
#define LEDGER_H

#include <stdint.h>
int ledger_init(void);
int ledger_deinit(void);

void ledger_record_pc(void *val);
void ledger_log_record(uintptr_t pc, uintptr_t fmt, ...);

#define LEDGER_TRACE() ledger_record_pc(__builtin_return_address(0))

#define LEDGER_LOGI(fmt, ...) ledger_log_record((uintptr_t)__builtin_return_address(0), (uintptr_t)(fmt), __VA_ARGS__)

#define LEDGER_ERROR(msg)

#endif
