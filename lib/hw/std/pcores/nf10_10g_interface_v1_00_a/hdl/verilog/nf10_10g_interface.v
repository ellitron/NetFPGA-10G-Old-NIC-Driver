////////////////////////////////////////////////////////////////////////
//
//  NetFPGA-10G http://www.netfpga.org
//
//  Module:
//          nf10_10g_interface
//
//  Description:
//          This is the combination of AXI interface, 10G MAC and XAUI
//          C_XAUI_REVERSE=1 means the XAUI GTX lanes are reversed. This
//          is used on NetFPGA-10G board Port 0, 1, 2. Please consult
//          board schematic first before modifying the default value.
//
//                          / rx_queue (AXI Master)
//          XAUI - 10G MAC 
//                          \ tx_queue (AXI Slave)
//                 
//  Revision history:
//          2010/11/28 hyzeng: Initial check-in
//
////////////////////////////////////////////////////////////////////////

module nf10_10g_interface
#(
    // Master AXI Stream Data Width
    parameter C_M_AXIS_DATA_WIDTH=64,
    parameter C_S_AXIS_DATA_WIDTH=64,
    parameter C_INCLUDE_ERR=1,
    parameter C_XAUI_REVERSE=0,
    parameter C_XGMAC_CONFIGURATION = {5'b01000, 64'h0583000000000000},
    parameter C_XAUI_CONFIGURATION = 7'b0
)
(
    // Part 1: System side signals
    // Global Ports
    input axi_aclk,
    input axi_resetn,
    
    input dclk,   //DRP Clock 50MHz
    input refclk, //GTX Clock 156.25MHz
    
    // Master Stream Ports
    output [C_M_AXIS_DATA_WIDTH - 1:0] m_axis_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_tstrb,
    output m_axis_tvalid,
    input  m_axis_tready,
    output m_axis_tlast,
    
    output m_axis_err_tvalid,
    
    // Slave Stream Ports
    input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_tstrb,
    input  s_axis_tvalid,
    output s_axis_tready,
    input  s_axis_tlast,
    
    // Part 2: PHY side signals
    // XAUI PHY Interface
    output        xaui_tx_l0_p,
    output        xaui_tx_l0_n,
    output        xaui_tx_l1_p,
    output        xaui_tx_l1_n,
    output        xaui_tx_l2_p,
    output        xaui_tx_l2_n,
    output        xaui_tx_l3_p,
    output        xaui_tx_l3_n,
    
    input         xaui_rx_l0_p,
    input         xaui_rx_l0_n,
    input         xaui_rx_l1_p,
    input         xaui_rx_l1_n,
    input         xaui_rx_l2_p,
    input         xaui_rx_l2_n,
    input         xaui_rx_l3_p,
    input         xaui_rx_l3_n
);

  wire clk156, txoutclk;
  
  wire [63:0] xgmii_rxd, xgmii_txd;
  wire [ 7:0] xgmii_rxc, xgmii_txc;
  
  wire [63 : 0] tx_data;
  wire [7 : 0]  tx_data_valid;
  wire          tx_start;
  wire          tx_ack;
 
  wire [63 : 0] rx_data;
  wire [7 : 0]  rx_data_valid;
  
  wire          rx_good_frame;
  wire          rx_bad_frame;

  wire reset = ~axi_resetn;  

  // =============================================================================
  // Module Instantiation
  // ============================================================================= 

  // Put system clocks on global routing
  BUFG clk156_bufg (
    .I(txoutclk),
    .O(clk156));

  xaui_block 
  #(.WRAPPER_SIM_GTXRESET_SPEEDUP(1),
    .REVERSE_LANES(C_XAUI_REVERSE) 
   ) xaui_block
  (
    .reset         (reset),
    .reset156      (reset),
    .clk156        (clk156),
    .dclk          (dclk),
    .refclk        (refclk),
    .txoutclk      (txoutclk),
    
    .xgmii_txd     (xgmii_txd),
    .xgmii_txc     (xgmii_txc),
    .xgmii_rxd     (xgmii_rxd),
    .xgmii_rxc     (xgmii_rxc),
    
    .xaui_tx_l0_p  (xaui_tx_l0_p),
    .xaui_tx_l0_n  (xaui_tx_l0_n),
    .xaui_tx_l1_p  (xaui_tx_l1_p),
    .xaui_tx_l1_n  (xaui_tx_l1_n),
    .xaui_tx_l2_p  (xaui_tx_l2_p),
    .xaui_tx_l2_n  (xaui_tx_l2_n),
    .xaui_tx_l3_p  (xaui_tx_l3_p),
    .xaui_tx_l3_n  (xaui_tx_l3_n),
    .xaui_rx_l0_p  (xaui_rx_l0_p),
    .xaui_rx_l0_n  (xaui_rx_l0_n),
    .xaui_rx_l1_p  (xaui_rx_l1_p),
    .xaui_rx_l1_n  (xaui_rx_l1_n),
    .xaui_rx_l2_p  (xaui_rx_l2_p),
    .xaui_rx_l2_n  (xaui_rx_l2_n),
    .xaui_rx_l3_p  (xaui_rx_l3_p),
    .xaui_rx_l3_n  (xaui_rx_l3_n),
    
    .txlock        (clk156_locked),
    .signal_detect (4'b1111),
    .drp_i         (16'h0),
    .drp_addr      (7'b0),
    .drp_en        (2'b0),
    .drp_we        (2'b0),
    .drp_o         (),
    .drp_rdy       (),
    .configuration_vector (C_XAUI_CONFIGURATION),
    .status_vector ()
  );


   ////////////////////////
   // Instantiate the MAC
   ////////////////////////
   xgmac xgmac
     (
      .reset                (reset),
    
      .tx_underrun          (1'b0),
      .tx_data              (tx_data),
      .tx_data_valid        (tx_data_valid),
      .tx_start             (tx_start),
      .tx_ack               (tx_ack),
      .tx_ifg_delay         (8'b0),
      .tx_statistics_vector (),
      .tx_statistics_valid  (),
      .pause_val            (16'h0),
      .pause_req            (1'b0),
    
      .rx_data              (rx_data),
      .rx_data_valid        (rx_data_valid),
      .rx_good_frame        (rx_good_frame),
      .rx_bad_frame         (rx_bad_frame),
      .rx_statistics_vector (),
      .rx_statistics_valid  (),
    
      .configuration_vector (C_XGMAC_CONFIGURATION),

      .tx_clk0(clk156),
      .tx_dcm_lock(clk156_locked),
      .xgmii_txd(xgmii_txd),
      .xgmii_txc(xgmii_txc),

      .rx_clk0(clk156),
      .rx_dcm_lock(clk156_locked),
      .xgmii_rxd(xgmii_rxd),
      .xgmii_rxc(xgmii_rxc)
      );
      
    ////////////////////////////////
    // Instantiate the AXI Converter
    ////////////////////////////////
    rx_queue #(
       .AXI_DATA_WIDTH(C_M_AXIS_DATA_WIDTH)
    )rx_queue (
       // AXI side 
       .tdata(m_axis_tdata),
       .tstrb(m_axis_tstrb),
       .tvalid(m_axis_tvalid),
       .tlast(m_axis_tlast),
       .tready(m_axis_tready),
       
       .err_tvalid(m_axis_err_tvalid),
       
       .clk(axi_aclk),
       .reset(~axi_resetn),
       
       // MAC side
       .rx_data(rx_data),
       .rx_data_valid(rx_data_valid),
       .rx_good_frame(rx_good_frame),
       .rx_bad_frame(rx_bad_frame),
       .clk156(clk156)
    );

    tx_queue #(
       .AXI_DATA_WIDTH(C_S_AXIS_DATA_WIDTH)
    )
    tx_queue (
       // AXI side 
       .tdata(s_axis_tdata),
       .tstrb(s_axis_tstrb),
       .tvalid(s_axis_tvalid),
       .tlast(s_axis_tlast),
       .tready(s_axis_tready),
       
       .clk(axi_aclk),
       .reset(~axi_resetn),
       
       // MAC side
       .tx_data(tx_data),
       .tx_data_valid(tx_data_valid),
       .tx_start(tx_start),
       .tx_ack(tx_ack),
       .clk156(clk156)
    );
      
endmodule
