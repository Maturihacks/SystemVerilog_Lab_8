class mult_driver;
  mult_sb sb;
  virtual mult_ports ports;
  virtual mult_monitor_ports mports;

  bit rdDone;
  bit wrDone;

  integer wr_cmds;
  integer rd_cmds;

  function new (virtual mult_ports ports, virtual mult_monitor_ports mports);
  begin
    $write("New Driver");
    this.ports = ports;
    this.mports = mports;
    sb = new();
    wr_cmds = 5;
    rd_cmds = 5;
    rdDone = 0;
    wrDone = 0;
    ports.Valid  = 0;
    ports.A  = 0;
    ports.B  = 0;
  end
  endfunction
  
  task monitorPush();
  begin
    bit [7:0] data_A = 0;
    bit [7:0] data_B = 0;
    while (1) begin
      @ (posedge mports.clk);
      if (mports.Valid == 1) begin
        data_A = mports.A;
        data_B = mports.B;
        sb.addItem(data_A);
	sb.addItem(data_B);
        $write("%dns : Write posting to scoreboard data_A = %x, data_B = %x\n",$time, data_A, data_B);
      end
    end
  end
  endtask

  task monitorPop();
  begin
    bit [15:0] data = 0;
    while (1) begin
      @ (posedge mports.clk);
      if (mports.Done == 1) begin
        data = mports.Y;
        $write("%dns : Read posting to scoreboard data = %x\n",$time, data);
        sb.compareItem(data);
      end
    end
  end
  endtask

  task go();
  begin
    // Assert reset first
    reset();
    // Start the monitors
    repeat (5) @ (posedge ports.clk);
    $write("%dns : Starting Pop and Push monitors\n",$time);
    fork
      monitorPop();
      monitorPush();
    join_none
    $write("%dns : Starting Pop and Push generators\n",$time);
    fork
      genPush();
      genPop(); 
    join_none

    while (!rdDone && !wrDone) begin
      @ (posedge ports.clk);
    end
    repeat (10) @ (posedge ports.clk);
    $write("%dns : Terminating simulations\n",$time);
    $finish;
  end
  endtask

  task reset();
  begin
    repeat (5) @ (posedge ports.clk);
    $write("%dns : Asserting reset\n",$time);
    ports.rst= 1'b1;
    // Init all variables
    rdDone = 0;
    wrDone = 0;
    repeat (5) @ (posedge ports.clk);
    ports.rst= 1'b0;
    $write("%dns : Done asserting reset\n",$time);
  end
  endtask

  task genPush();
  begin
    bit [7:0] data_A = 0;
    bit [7:0] data_B = 0;
    integer i = 0;
    for ( i  = 0; i < wr_cmds; i++)  begin
       data_A = $random();
       data_B = $random();
       @ (posedge ports.clk);
       while (ports.full== 1'b1) begin
        ports.Valid  = 1'b0;
        ports.A= 8'b0;
        ports.B= 8'b0;
        @ (posedge ports.clk); 
       end
       ports.B  = 1'b1;
       ports.A = data_A;
       ports.B = data_B;
    end
    @ (posedge ports.clk);
    ports.Valid  = 1'b0;
    ports.A= 8'b0;
    ports.B= 8'b0;
    repeat (10) @ (posedge ports.clk);
    wrDone = 1;
  end
  endtask
  
  task genPop();
  begin
    integer i = 0;
    for ( i  = 0; i < rd_cmds; i++)  begin
       @ (posedge ports.clk);
       while (ports.empty== 1'b1) begin
         //ports.Done  = 1'b0;
         @ (posedge ports.clk); 
       end
       //ports.Done  = 1'b1;
    end
    @ (posedge ports.clk);
    //ports.Done   = 1'b0;
    repeat (10) @ (posedge ports.clk);
    rdDone = 1;
  end
  endtask
endclass