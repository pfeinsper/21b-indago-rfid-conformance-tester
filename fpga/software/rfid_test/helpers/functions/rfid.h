#ifndef RFID_H
#define RFID_H

#include "../config.h"
#include "system.h"
#include "../commands/commands.h"
#include "io.h"

void rfid_set_loopback(void);

void rfid_set_tari(int);

void rfid_set_tari_boundaries(int, int, int, int, int, int, int, int);

int rfid_create_mask_from_value(int);

int rfid_check_command(int[], int);

int rfid_tari_2_clock(double, double);

int rfid_get_ip_id(void);
#endif /* RFID_H */
