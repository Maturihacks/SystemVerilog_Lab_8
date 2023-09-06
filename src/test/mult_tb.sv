`include "../rtl/top_level.sv"
`include "./mult_top.sv"

module mult_tb#(parameter N = 8)();

logic clk;
logic rst;
logic Valid;
logic [N-1:0] A;
logic [N-1:0] B;
logic Done;
logic [2*N-1:0] Y;
wire full, empty;

mult_ports ports (
  .clk           (clk     ),
  .rst           (rst     ),
  .Valid         (Valid   ),
  .A             (A       ),
  .B             (B       ),
  .Done          (Done    ),
  .Y             (Y       ),
  .full          (full    ),
  .empty         (empty   )
);

mult_monitor_ports mports (
  .clk           (clk     ),
  .rst           (rst     ),
  .Valid         (Valid   ),
  .A             (A       ),
  .B             (B       ),
  .Done          (Done    ),
  .Y             (Y       ),
  .full          (full    ),
  .empty         (empty   )
);


mult_top mult_top (ports, mports);

  
initial begin
  //$dumpfile("mult.vcd");
  //$dumpvars();
  clk = 0;
end

always #1 clk  = ~clk;

top_level top(.clk(clk), .reset(rst), .Valid(Valid), .A(A), .B(B), .Done(Done), .Y(Y));


endmodule