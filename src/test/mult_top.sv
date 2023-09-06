`include "../packages/mult_ports.sv"

module mult_top (mult_ports ports, mult_monitor_ports mports);
  `include "../packages/mult_sb.sv"
  `include "../packages/mult_driver.sv"

  mult_driver driver = new(ports, mports);

  initial begin
    driver.go();
  end

endmodule