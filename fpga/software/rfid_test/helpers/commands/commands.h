// Mandatory Commands
#include "query_rep.h"
#include "ack.h"
#include "query.h"
#include "query_adjust.h"
#include "select.h"
#include "nak.h"
#include "req_rn.h"
#include "read.h"
#include "write.h"
#include "kill.h"
#include "lock.h"
#include "rn16.h"


// Defining commands labels
#define ACK_LABEL          0
#define KILL_LABEL         1
#define LOCK_LABEL         2 
#define NAK_LABEL          3
#define QUERY_ADJUST_LABEL 4
#define QUERY_REP_LABEL    5
#define QUERY_LABEL        6
#define READ_LABEL         7
#define REQ_RN_LABEL       8
#define RN16_LABEL         9
#define SELECT_LABEL       10
#define WRITE_LABEL        11