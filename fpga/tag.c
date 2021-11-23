#include "io.h"
#include "system.h"
#include "stdint.h"
#include "helpers/commands/commands.h"
#include "stdio.h"

// REGISTER STATUS
#define BASE_IS_FIFO_FULL    (1 << 0)
#define MASK_EMPTY_RECEIVER  (1 << 13)

// REGISTER SETTINGS
#define BASE_REG_SET          0        
#define MASK_RST             (1 << 0)
#define MASK_EN              (1 << 1)
#define MASK_RST_RECEIVER    (1 << 10)
#define MASK_EN_RECEIVER     (1 << 4)
#define MASK_CLR_FIFO        (1 << 2)
#define MASK_LOOPBACK        (1 << 8)
#define MASK_CLR_FINISHED    1 << 1
// #define MASK_CLR_FINISHED_0  0 << 1
#define SENDER_HAS_GEN       0 << 5 
#define SENDER_ENABLE_CTRL   1 << 6
// #define SENDER_ENABLE_CTRL_0 0 << 6
#define SENDER_IS_PREAMBLE   0 << 7
#define MASK_READ_REQ        1 << 12

// RFID - WRITE
#define BASE_REG_TARI       1       
#define BASE_REG_FIFO       2
#define BASE_REG_TARI_101   3
#define BASE_REG_TARI_099   4
#define BASE_REG_TARI_1616  5
#define BASE_REG_TARI_1584  6
#define BASE_REG_PW         7
#define BASE_REG_DELIMITER  8
#define BASE_REG_RTCAL      9
#define BASE_REG_TRCAL      10

// RFID - READ
#define BASE_REG_STATUS     3
#define BASE_RECEIVER_DATA  4
#define BASE_SENDER_USEDW   5
#define BASE_RECEIVER_USEDW 6
#define BASE_ID             7
#define MASK_FINISH_SEND    (1 << 3)

// package defines
#define data_mask_size      6
#define data_package_size   26
#define eop                 0b00000000000000000000000000000000
#define bits26              0b11111111111111111111111111
#define bits32              0b11111111111111111111111111111111

// tudo isso precisa virar input
int tari_test = 0x1f4;
int tari_101  = 0x1f9;
int	tari_099  = 0x1EF;
int tari_1616 = 0x328;
int tari_1584 = 0x318;
int pw        = 0xFA;
int delimiter = 0x271;
int RTcal     = 0x546;
int TRcal     = 0x546;



// RFID -----------------------------------------------------------------------------------------------------------
void rfid_set_loopback(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_LOOPBACK);}

void rfid_set_tari(int tari_value){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI << 2, tari_value);}

void rfid_set_tari_bounderies(int tari_101, int tari_099, int tari_1616, int tari_1584, int pw, int delimiter, int RTcal, int TRcal){
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_101 << 2, tari_101);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_099 << 2, tari_099);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_1616 << 2, tari_1616);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_1584 << 2, tari_1584);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_PW << 2, pw);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_DELIMITER << 2, delimiter);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_RTCAL << 2, RTcal);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TRCAL << 2, TRcal);}

int rfid_create_mask_from_value(int value){
    int mask = 0;
    for (int i = 0; i < value; i++)
    {
        mask = mask << 1;
        mask = mask | 1;
    }
    return mask;
}

int rfid_get_ip_id(){return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_ID << 2);}
// SENDER -----------------------------------------------------------------------------------------------------------
int  sender_check_usedw() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE,  BASE_SENDER_USEDW <<2 );}

int  sender_check_fifo_full() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & BASE_IS_FIFO_FULL; }

void sender_enable(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_LOOPBACK | MASK_EN);}

void sender_send_package(int package) {
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, package);
	//printf("sender_send_package %d \n", package);
}

void sender_send_end_of_package() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, eop); }

void sender_start_ctrl(){
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN | SENDER_ENABLE_CTRL);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);}

void sender_write_clr_finished_sending(){
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_CLR_FINISHED | MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);}

int sender_read_finished_send(){return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & MASK_FINISH_SEND;}

void sender_add_mask(int n, int command_vector_masked[n],unsigned long long result_data, unsigned int result_data_size){
    //printf("result_data is: %d and result_data_size is, %d\n", result_data,result_data_size);
    int last_package_size = result_data_size % data_package_size;
    int quant_packages = result_data_size/data_package_size + 1;
    //printf("last_package_size is: %d and quant_packages is, %d\n", last_package_size,quant_packages);
    for(int current_package = 1; current_package <= quant_packages; current_package++){
        //printf("FOR LOOP current_package is: %d and quant_packages is, %d\n", current_package,quant_packages);
        int quant_bits_this_package;
        if (current_package == quant_packages){
            // case when we cant fill a package with 26 bits
            quant_bits_this_package = last_package_size;
        }
        else {
            // case when data is bigger thant 26 bits
            quant_bits_this_package = 0x1A;
        }

        // deviding package and adding mask to it
        int unmasked_package = result_data & bits26; // 26 bits
        int masked_package = unmasked_package << 6 | quant_bits_this_package;
        command_vector_masked[current_package-1] = masked_package;

        // shifting result_data to remove bits that are already treated
        result_data = result_data >> quant_bits_this_package;

    }
}

int sender_get_command_ints_size(int size_of_command){
		return (size_of_command/26)+1;
    }

void sender_has_gen(int usesPreorFrameSync){if(usesPreorFrameSync){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_EN_RECEIVER | SENDER_HAS_GEN);}}

void sender_is_preamble(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);}

// RECEIVER -----------------------------------------------------------------------------------------------------------
void receiver_enable(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2 , MASK_EN | MASK_LOOPBACK |MASK_EN_RECEIVER);}

int receiver_get_package(){return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_RECEIVER_DATA<<2);}

int receiver_empty(){
    int is_empty = IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & MASK_EMPTY_RECEIVER;
    // printf(" receiver is empty: %d \n",is_empty);
    return is_empty >> 13;
    }

void receiver_rdreq(){
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_READ_REQ |MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2,  MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);
}
//-----------------------------------------------------------------------------------------------------------

int main()
{
    //configurations------------------------------------------------------------------------------
	rfid_set_loopback();
    rfid_set_tari(tari_test);
    sender_enable();
    
    receiver_enable();
    rfid_set_tari_bounderies(tari_101,tari_099,tari_1616,tari_1584,pw,delimiter,RTcal,TRcal);
    sender_has_gen(0);
    //sender_is_preamble();
    printf("IP conneced ID is: %04X \n",rfid_get_ip_id());

    // HANDSHAKE EXAMPLE TAG -----------------------------------------------------------------------
    // WAIT A QUERY ----------------------------------------------------------------------------------
    int pack_query = 2;

    while(pack_query != 0){
        while(receiver_empty()){
            //printf("receiver_empty is: %d \n", receiver_empty());
        };
        pack_query = receiver_get_package();
        int mask_value = pack_query & 0b111111;
        int data = pack_query >> 6;
        int mask = 0;
        for (int i = 0; i < mask_value; i++)
        {
            mask = mask << 1;
            mask = mask | 1;
        }
        if(query_validate(data,mask)){
            printf("QUERY RECEIVED\n" );
        }else{
            printf("ERROR IN QUERY\n" );
        }
        data = data & mask;
        
        printf("data received query = %d\n", pack_query);
        printf("data received = %d\n", data);
        printf("mask_value = %d\n", mask_value);
        receiver_rdreq();
   };

   //ANSWER WITH RANDOM NUMBER ------------------------------------------------------------------------------
  rn16 rn;
  
  rn.value = rn16_generate();
  rn.size  = 11;
  printf("command rn = %d\n", rn.value);
  int size_with_mask_rn = sender_get_command_ints_size(rn.size);

  int command_vector_masked_rn[size_with_mask_rn];

  // adding masks to each package of the command
  sender_add_mask(size_with_mask_rn, command_vector_masked_rn, rn.value, rn.size);

  // wait for fifo avalability to receive packages
  for (int i = 0; i < size_with_mask_rn; i++)
  {
      while (sender_check_fifo_full()){}
      sender_send_package(command_vector_masked_rn[i]);
  }

  sender_send_end_of_package();

  sender_start_ctrl();

  while(!sender_read_finished_send()){}

  sender_write_clr_finished_sending();


  //WAIT AN ACK-------------------------------------------------------------------------------------------------------

  int pack_ack = 2;

   while(pack_ack != 0){
       while(receiver_empty()){
           //printf("receiver_empty is: %d \n", receiver_empty());
       };
       pack_ack = receiver_get_package();
       int mask_value = pack_ack & 0b111111;
       int data = pack_ack >> 6;
       int mask = 0;
       for (int i = 0; i < mask_value; i++)
       {
           mask = mask << 1;
           mask = mask | 1;
       }
       if(ack_validate(data,mask)){
            printf("ACK RECEIVED\n" );
        }else{
            printf("ERROR IN QUERY\n" );
        }
       data = data & mask;
       
       printf("data received ack = %d\n", pack_ack);
       printf("data received = %d\n", data);
       printf("mask_value = %d\n", mask_value);
       receiver_rdreq();
   };
    
   //ANSWER WITH A PC------------------------------------------------------
    rn16 rn;

    rn.value = rn16_generate();
    rn.size  = 11;
    printf("command rn = %d\n", rn.value);
    int size_with_mask_rn = sender_get_command_ints_size(rn.size);

    int command_vector_masked_rn[size_with_mask_rn];

    // adding masks to each package of the command
    sender_add_mask(size_with_mask_rn, command_vector_masked_rn, rn.value, rn.size);

    // wait for fifo avalability to receive packages
    for (int i = 0; i < size_with_mask_rn; i++)
    {
        while (sender_check_fifo_full()){}
        sender_send_package(command_vector_masked_rn[i]);
    }

    sender_send_end_of_package();

    sender_start_ctrl();

    while(!sender_read_finished_send()){}

    sender_write_clr_finished_sending();

   //WAIT A REQRN-------------------------------------------------------------------------------------------------------
    int pack_req_rn = 2;

    while(pack_req_rn != 0){
        while(receiver_empty()){
            // printf("receiver_empty is: %d \n", receiver_empty());
        };
        pack_req_rn = receiver_get_package();
        int mask_value = pack_req_rn & 0b111111;
        int data = pack_req_rn >> 6;
        int mask = 0;
        for (int i = 0; i < mask_value; i++)
        {
            mask = mask << 1;
            mask = mask | 1;
        }
    
        data = data & mask;
        
        printf("data received rn = %d\n", pack_req_rn);
        printf("data received = %d\n", data);
        printf("mask_value = %d\n", mask_value);
        receiver_rdreq();
   };


    printf("End of Communication with IP = %04X \n",rfid_get_ip_id());
    return 0;
}
