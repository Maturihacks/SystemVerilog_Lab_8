`include "../rtl/mult_control.sv"
`include "../rtl/counter.sv"
`include "../rtl/FSM.sv"
`include "../rtl/mult_datapath.sv"

module top_level#(parameter N = 8)(
    input  logic clk,
    input  logic reset,
    input  logic Valid,
    input  logic [N-1:0] A,
    input  logic [N-1:0] B,
    output logic Done,
    output logic [2*N-1:0] Y
);

logic shift;
logic count;
logic [2]Q_LSB;
logic Q0;
logic Q_1;
mult_control_t mult_control;

always_comb begin
    Q_1 = Q_LSB[0];
    Q0  = Q_LSB[1];
end

counter_fsm counter_mult(.clk(clk), .reset(reset), .shift(shift), .ticks(ticks));

mult_with_no_fsm mult_machine(.clk(clk), .rst(reset), .A(A), .B(B), .mult_control(mult_control), .Q_LSB(Q_LSB), .Y(Y));

mult_fsm fsm(.clk(clk), .reset(reset), .Valid(Valid), .Q0(Q0), .Q_1(Q_1), .ticks(ticks), .mult_control(mult_control), .Done(Done));

endmodule
