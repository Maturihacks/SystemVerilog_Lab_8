module counter_fsm#(parameter N = 8)
(
    input  logic clk,
    input  logic reset,
    input logic shift,
    output logic ticks
) ;
parameter q_size=$clog2(N);
logic [q_size-1:0] q;

always_ff @(posedge clk, posedge reset)
    if (reset) begin
        q <= '0;
	ticks <= '0;
	end
    else begin
	if (shift) begin
     		q<= q + 1'b1;
		if (q==N)begin
			ticks <= '1;
			q <= '0;
			end
		else
			ticks <= '0;
		end
	end	
endmodule 