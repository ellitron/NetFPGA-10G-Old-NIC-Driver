////////////////////////////////////////////////////////////////////////
//
//  NetFPGA-10G http://www.netfpga.org
//
//  Module:
//          system_tb
//
//  Description:
//          System testbench for loopback_test_1g
//                 
//  Revision history:
//          2010/12/20 hyzeng: Initial check-in
//
////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1ps

`uselib lib=unisims_ver

// START USER CODE (Do not remove this line)

// User: Put your directives here. Code in this
//       section will not be overwritten.

// END USER CODE (Do not remove this line)

module system_tb
  (
  );

  // START USER CODE (Do not remove this line)

  // User: Put your signals here. Code in this
  //       section will not be overwritten.
  integer             i;
  
  // END USER CODE (Do not remove this line)

  reg RESET;
  wire RS232_Uart_1_sout;
  reg RS232_Uart_1_sin;
  reg CLK;
  wire MDC;
  wire MDIO;
  wire PHY_RST_N;
  reg nf10_1g_interface_0_RXN_1_pin;
  wire nf10_1g_interface_0_TXN_1_pin;
  wire nf10_1g_interface_0_TXP_0_pin;
  wire nf10_1g_interface_0_TXN_0_pin;
  wire nf10_1g_interface_0_TXP_1_pin;
  reg nf10_1g_interface_0_RXP_0_pin;
  reg nf10_1g_interface_0_RXN_0_pin;
  reg nf10_1g_interface_0_RXP_1_pin;
  reg nf10_1g_interface_1_RXN_1_pin;
  reg nf10_1g_interface_1_RXP_1_pin;
  wire nf10_1g_interface_1_TXP_0_pin;
  wire nf10_1g_interface_1_TXN_0_pin;
  wire nf10_1g_interface_1_TXP_1_pin;
  reg nf10_1g_interface_1_RXP_0_pin;
  reg nf10_1g_interface_1_RXN_0_pin;
  wire nf10_1g_interface_1_TXN_1_pin;
  reg refclk_A_p;
  reg refclk_A_n;
  reg refclk_B_p;
  reg refclk_B_n;
  reg refclk_C_p;
  reg refclk_C_n;
  reg refclk_D_p;
  reg refclk_D_n;
  
  system
    dut (
      .RESET ( RESET ),
      .RS232_Uart_1_sout ( RS232_Uart_1_sout ),
      .RS232_Uart_1_sin ( RS232_Uart_1_sin ),
      .CLK ( CLK ),
      .MDC ( MDC ),
      .MDIO ( MDIO ),
      .PHY_RST_N ( PHY_RST_N ),
      .nf10_1g_interface_0_RXN_1_pin ( nf10_1g_interface_0_RXN_1_pin ),
      .nf10_1g_interface_0_TXN_1_pin ( nf10_1g_interface_0_TXN_1_pin ),
      .nf10_1g_interface_0_TXP_0_pin ( nf10_1g_interface_0_TXP_0_pin ),
      .nf10_1g_interface_0_TXN_0_pin ( nf10_1g_interface_0_TXN_0_pin ),
      .nf10_1g_interface_0_TXP_1_pin ( nf10_1g_interface_0_TXP_1_pin ),
      .nf10_1g_interface_0_RXP_0_pin ( nf10_1g_interface_0_RXP_0_pin ),
      .nf10_1g_interface_0_RXN_0_pin ( nf10_1g_interface_0_RXN_0_pin ),
      .nf10_1g_interface_0_RXP_1_pin ( nf10_1g_interface_0_RXP_1_pin ),
      .nf10_1g_interface_1_RXN_1_pin ( nf10_1g_interface_1_RXN_1_pin ),
      .nf10_1g_interface_1_RXP_1_pin ( nf10_1g_interface_1_RXP_1_pin ),
      .nf10_1g_interface_1_TXP_0_pin ( nf10_1g_interface_1_TXP_0_pin ),
      .nf10_1g_interface_1_TXN_0_pin ( nf10_1g_interface_1_TXN_0_pin ),
      .nf10_1g_interface_1_TXP_1_pin ( nf10_1g_interface_1_TXP_1_pin ),
      .nf10_1g_interface_1_RXP_0_pin ( nf10_1g_interface_1_RXP_0_pin ),
      .nf10_1g_interface_1_RXN_0_pin ( nf10_1g_interface_1_RXN_0_pin ),
      .nf10_1g_interface_1_TXN_1_pin ( nf10_1g_interface_1_TXN_1_pin ),
      .refclk_A_p ( refclk_A_p ),
      .refclk_A_n ( refclk_A_n ),
      .refclk_B_p ( refclk_B_p ),
      .refclk_B_n ( refclk_B_n ),
      .refclk_C_p ( refclk_C_p ),
      .refclk_C_n ( refclk_C_n ),
      .refclk_D_p ( refclk_D_p ),
      .refclk_D_n ( refclk_D_n )
    );

  // START USER CODE (Do not remove this line)

  // User: Put your stimulus here. Code in this
  //       section will not be overwritten.
  
  // Part 1: Wire connection
  always @(*) begin
      // Port 0 to Port 1
      nf10_1g_interface_0_RXP_0_pin = nf10_1g_interface_0_TXP_1_pin;
      nf10_1g_interface_0_RXN_0_pin = nf10_1g_interface_0_TXN_1_pin;
      nf10_1g_interface_0_RXP_1_pin = nf10_1g_interface_0_TXP_0_pin;
      nf10_1g_interface_0_RXN_1_pin = nf10_1g_interface_0_TXN_0_pin;
      
      // Port 2 to Port 3
      nf10_1g_interface_1_RXP_0_pin = nf10_1g_interface_1_TXP_1_pin;
      nf10_1g_interface_1_RXN_0_pin = nf10_1g_interface_1_TXN_1_pin;
      nf10_1g_interface_1_RXP_1_pin = nf10_1g_interface_1_TXP_0_pin;
      nf10_1g_interface_1_RXN_1_pin = nf10_1g_interface_1_TXN_0_pin;
  end
  
  // Part 2: Reset
  initial begin
      RS232_Uart_1_sin = 1'b0;
      CLK   = 1'b0;
      
      refclk_A_p = 1'b0;
      refclk_A_n = 1'b1;
      refclk_B_p = 1'b0;
      refclk_B_n = 1'b1;
      refclk_C_p = 1'b0;
      refclk_C_n = 1'b1;      
      refclk_D_p = 1'b0;
      refclk_D_n = 1'b1;
              
      $display("[%t] : System Reset Asserted...", $realtime);
      RESET = 1'b0;
      for (i = 0; i < 50; i = i + 1) begin
                 @(posedge CLK);
      end
      $display("[%t] : System Reset De-asserted...", $realtime);
      RESET = 1'b1;
  end
  
  
  // Part 3: Clock
  always #5  CLK = ~CLK;      // 100MHz
  always #4 refclk_A_p = ~refclk_A_p; // 125MHz
  always #4 refclk_A_n = ~refclk_A_n; // 125MHz
  always #4 refclk_B_p = ~refclk_B_p; // 125MHz
  always #4 refclk_B_n = ~refclk_B_n; // 125MHz
  always #4 refclk_C_p = ~refclk_C_p; // 125MHz
  always #4 refclk_C_n = ~refclk_C_n; // 125MHz
  always #4 refclk_D_p = ~refclk_D_p; // 125MHz
  always #4 refclk_D_n = ~refclk_D_n; // 125MHz


  // END USER CODE (Do not remove this line)

endmodule

