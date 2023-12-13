
module test_i2c_master();
  reg     clk_tb, rd_wr_tb, start_tb, stop_tb, reset_tb;
  reg     [6:0] address_tb;
  reg     [7:0] din_tb;
  wire    SDA_tb;
  wire    SCL_tb;
  wire    [7:0] dout_tb;

i2c_master dut (
  .clk(clk_tb),
  .rd_wr(rd_wr_tb),
  .start(start_tb),
  .stop(stop_tb),
  .reset(reset_tb),
  .address(address_tb),
  .din(din_tb),
  .SDA(SDA_tb),
  .SCL(SCL_tb),
  .dout(dout_tb)
);

  //DUMPS
  initial begin
    $dumpfile("i2c.vcd");
    $dumpvars(0, test_i2c_master);
    
    #1000 $finish;
  end

  // CLOCK GENERATION
  initial begin
    forever begin
      #5 clk_tb = ~clk_tb;
    end
  end

  // INITIALIZING VALUES
  initial begin
    clk_tb      = 1'b0; 
    rd_wr_tb    = 1'b0; 
    start_tb    = 1'b0; 
    stop_tb     = 1'b0; 
    reset_tb    = 1'b0;
    address_tb  = 7'b0;
    din_tb      = 8'b0;
  end

  initial begin
    #10 reset_tb    = 1'b1;
    #10 reset_tb    = 1'b0;
    #10 start_tb    = 1'b1;
        rd_wr_tb    = 1'b1;
        address_tb  = 7'b1101;
        din_tb      = 8'b10010;
  end



endmodule
