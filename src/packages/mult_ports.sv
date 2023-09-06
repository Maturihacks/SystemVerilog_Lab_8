`ifndef MULT_PORTS_SV
`define MULT_PORTS_SV

interface mult_ports #(parameter N = 8)(
  input  wire        clk      ,
  output logic       rst      ,
  input  wire        full     ,
  input  wire        empty    ,
  output logic       Valid    ,
  output logic       [N-1:0] A,
  output logic       [N-1:0] B, 
  input  logic       Done     ,
  input  logic       [2*N-1:0] Y
);
endinterface


interface mult_monitor_ports #(parameter N = 8)(
  input  wire        clk      ,
  input  logic       rst      ,
  input wire         full     ,
  input wire         empty    ,
  input  logic       Valid    ,
  input  logic       [N-1:0] A,
  input  logic       [N-1:0] B, 
  input  logic       Done     ,
  input  logic       [2*N-1:0] Y
);
endinterface


`endif