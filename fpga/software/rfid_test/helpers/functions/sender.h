#ifndef SENDER_H
#define SENDER_H

#include "../config.h"
#include "system.h"
#include "../commands/commands.h"
#include "stdio.h"
#include "io.h"

int sender_check_usedw(void);

int sender_check_fifo_full(void);

void sender_enable(void);

void sender_send_package(int);

void sender_send_end_of_package(void);

void sender_start_ctrl(void);

void sender_write_clr_finished_sending(void);

int sender_read_finished_send(void);

void sender_add_mask(int , int[], unsigned long long*, unsigned int);

int sender_get_command_ints_size(int);

void sender_has_gen(int);

void sender_is_preamble(void);

void sender_send_command(command*);

#endif /* SENDER_H */
