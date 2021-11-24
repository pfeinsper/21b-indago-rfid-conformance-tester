#ifndef RN16_H
#define RN16_H

#define RN16_SIZE 16

typedef struct
{
    unsigned short result_data;
    unsigned int size;
} rn16;

void rn16_init(rn16 *rn16_ptr);

int rn16_validate(int command_size);

#endif /* RN16_H */
