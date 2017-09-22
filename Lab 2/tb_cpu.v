module tb_cpu_p1;
`timescale 1ns / 1ps
  reg clock;
  CPU cpu(clock);
  initial begin
      clock = 0;
      #400;
      $finish;
  end
  always begin
    #5
    clock = ~clock;
  end
endmodule
