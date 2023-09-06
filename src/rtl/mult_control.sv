`ifndef MULT_CONTROL_SV
`define MULT_CONTROL_SV
typedef struct {
    logic load_A ;
    logic load_B ;
    logic load_add ;
    logic shift_HQ_LQ_Q_1 ;
    logic add_sub ;
} mult_control_t ;
`endif