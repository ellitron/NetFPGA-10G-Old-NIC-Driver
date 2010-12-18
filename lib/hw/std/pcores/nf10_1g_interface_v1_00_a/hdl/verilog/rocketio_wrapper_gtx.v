////////////////////////////////////////////////////////////////////////
//
//  NetFPGA-10G http://www.netfpga.org
//
//  Module:
//          rocketio_wrapper_gtx
//
//  Description:
//          RocketIO Wrapper
//                 
//  Revision history:
//          2010/12/8 hyzeng: Initial check-in
//
////////////////////////////////////////////////////////////////////////



`timescale 1ns / 1ps


//***************************** Entity Declaration ****************************

module ROCKETIO_WRAPPER_GTX #
(
    // Simulation attributes
    parameter   WRAPPER_SIM_GTXRESET_SPEEDUP    = 0,    // Set to 1 to speed up sim reset
    parameter   WRAPPER_SIM_PLL_PERDIV2         = 9'h0c8   // Set to the VCO Unit Interval time    
)
(
    
    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE0  (Location)

    //---------------------- Loopback and Powerdown Ports ----------------------
    TILE0_LOOPBACK0_IN,
    TILE0_LOOPBACK1_IN,
    TILE0_RXPOWERDOWN0_IN,
    TILE0_TXPOWERDOWN0_IN,
    TILE0_RXPOWERDOWN1_IN,
    TILE0_TXPOWERDOWN1_IN,
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    TILE0_RXCHARISCOMMA0_OUT,
    TILE0_RXCHARISCOMMA1_OUT,
    TILE0_RXCHARISK0_OUT,
    TILE0_RXCHARISK1_OUT,
    TILE0_RXDISPERR0_OUT,
    TILE0_RXDISPERR1_OUT,
    TILE0_RXNOTINTABLE0_OUT,
    TILE0_RXNOTINTABLE1_OUT,
    TILE0_RXRUNDISP0_OUT,
    TILE0_RXRUNDISP1_OUT,
    //----------------- Receive Ports - Clock Correction Ports -----------------
    TILE0_RXCLKCORCNT0_OUT,
    TILE0_RXCLKCORCNT1_OUT,
    //------------- Receive Ports - Comma Detection and Alignment --------------
    TILE0_RXENMCOMMAALIGN0_IN,
    TILE0_RXENMCOMMAALIGN1_IN,
    TILE0_RXENPCOMMAALIGN0_IN,
    TILE0_RXENPCOMMAALIGN1_IN,
    //----------------- Receive Ports - RX Data Path interface -----------------
    TILE0_RXDATA0_OUT,
    TILE0_RXDATA1_OUT,
    TILE0_RXRECCLK0_OUT,
    TILE0_RXRECCLK1_OUT,
    TILE0_RXRESET0_IN,
    TILE0_RXRESET1_IN,
    TILE0_RXUSRCLK0_IN,
    TILE0_RXUSRCLK1_IN,
    TILE0_RXUSRCLK20_IN,
    TILE0_RXUSRCLK21_IN,
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    TILE0_RXELECIDLE0_OUT,
    TILE0_RXELECIDLE1_OUT,
    TILE0_RXN0_IN,
    TILE0_RXN1_IN,
    TILE0_RXP0_IN,
    TILE0_RXP1_IN,
    //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    TILE0_RXBUFRESET0_IN,
    TILE0_RXBUFRESET1_IN,
    TILE0_RXBUFSTATUS0_OUT,
    TILE0_RXBUFSTATUS1_OUT,
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    TILE0_CLKIN_IN,
    TILE0_GTXRESET_IN,
    TILE0_PLLLKDET_OUT,
    TILE0_REFCLKOUT_OUT,
    TILE0_RESETDONE0_OUT,
    TILE0_RESETDONE1_OUT,
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    TILE0_TXCHARDISPMODE0_IN,
    TILE0_TXCHARDISPMODE1_IN,
    TILE0_TXCHARDISPVAL0_IN,
    TILE0_TXCHARDISPVAL1_IN,
    TILE0_TXCHARISK0_IN,
    TILE0_TXCHARISK1_IN,
    //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
    TILE0_TXBUFSTATUS0_OUT,
    TILE0_TXBUFSTATUS1_OUT,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    TILE0_TXDATA0_IN,
    TILE0_TXDATA1_IN,
    TILE0_TXOUTCLK0_OUT,
    TILE0_TXOUTCLK1_OUT,
    TILE0_TXRESET0_IN,
    TILE0_TXRESET1_IN,
    TILE0_TXUSRCLK0_IN,
    TILE0_TXUSRCLK1_IN,
    TILE0_TXUSRCLK20_IN,
    TILE0_TXUSRCLK21_IN,
    //------------- Transmit Ports - TX Driver and OOB signalling --------------
    TILE0_TXN0_OUT,
    TILE0_TXN1_OUT,
    TILE0_TXP0_OUT,
    TILE0_TXP1_OUT


);


//***************************** Port Declarations *****************************
        


    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE0  (Location)

    //---------------------- Loopback and Powerdown Ports ----------------------
    input   [2:0]   TILE0_LOOPBACK0_IN;
    input   [2:0]   TILE0_LOOPBACK1_IN;
    input   [1:0]   TILE0_RXPOWERDOWN0_IN;
    input   [1:0]   TILE0_TXPOWERDOWN0_IN;
    input   [1:0]   TILE0_RXPOWERDOWN1_IN;
    input   [1:0]   TILE0_TXPOWERDOWN1_IN;
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    output          TILE0_RXCHARISCOMMA0_OUT;
    output          TILE0_RXCHARISK0_OUT;
    output          TILE0_RXDISPERR0_OUT;
    output          TILE0_RXNOTINTABLE0_OUT;
    output          TILE0_RXRUNDISP0_OUT;
    output          TILE0_RXCHARISCOMMA1_OUT;
    output          TILE0_RXCHARISK1_OUT;
    output          TILE0_RXDISPERR1_OUT;
    output          TILE0_RXNOTINTABLE1_OUT;
    output          TILE0_RXRUNDISP1_OUT;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    output  [2:0]   TILE0_RXCLKCORCNT0_OUT;
    output  [2:0]   TILE0_RXCLKCORCNT1_OUT;
    //------------- Receive Ports - Comma Detection and Alignment --------------
    input           TILE0_RXENMCOMMAALIGN0_IN;
    input           TILE0_RXENMCOMMAALIGN1_IN;
    input           TILE0_RXENPCOMMAALIGN0_IN;
    input           TILE0_RXENPCOMMAALIGN1_IN;
    //----------------- Receive Ports - RX Data Path interface -----------------
    output  [7:0]   TILE0_RXDATA0_OUT;
    output  [7:0]   TILE0_RXDATA1_OUT;
    output          TILE0_RXRECCLK0_OUT;
    output          TILE0_RXRECCLK1_OUT;
    input           TILE0_RXRESET0_IN;
    input           TILE0_RXRESET1_IN;
    input           TILE0_RXUSRCLK0_IN;
    input           TILE0_RXUSRCLK1_IN;
    input           TILE0_RXUSRCLK20_IN;
    input           TILE0_RXUSRCLK21_IN;
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    output          TILE0_RXELECIDLE0_OUT;
    output          TILE0_RXELECIDLE1_OUT;
    input           TILE0_RXN0_IN;
    input           TILE0_RXN1_IN;
    input           TILE0_RXP0_IN;
    input           TILE0_RXP1_IN;
    //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    input           TILE0_RXBUFRESET0_IN;
    input           TILE0_RXBUFRESET1_IN;
    output  [2:0]   TILE0_RXBUFSTATUS0_OUT;
    output  [2:0]   TILE0_RXBUFSTATUS1_OUT;
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    input           TILE0_CLKIN_IN;
    input           TILE0_GTXRESET_IN;
    output          TILE0_PLLLKDET_OUT;
    output          TILE0_REFCLKOUT_OUT;
    output          TILE0_RESETDONE0_OUT;
    output          TILE0_RESETDONE1_OUT;
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    input           TILE0_TXCHARDISPMODE0_IN;
    input           TILE0_TXCHARDISPMODE1_IN;
    input           TILE0_TXCHARDISPVAL0_IN;
    input           TILE0_TXCHARDISPVAL1_IN;
    input           TILE0_TXCHARISK0_IN;
    input           TILE0_TXCHARISK1_IN;
    //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
    output  [1:0]   TILE0_TXBUFSTATUS0_OUT;
    output  [1:0]   TILE0_TXBUFSTATUS1_OUT;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input   [7:0]   TILE0_TXDATA0_IN;
    input   [7:0]   TILE0_TXDATA1_IN;
    output          TILE0_TXOUTCLK0_OUT;
    output          TILE0_TXOUTCLK1_OUT;
    input           TILE0_TXRESET0_IN;
    input           TILE0_TXRESET1_IN;
    input           TILE0_TXUSRCLK0_IN;
    input           TILE0_TXUSRCLK1_IN;
    input           TILE0_TXUSRCLK20_IN;
    input           TILE0_TXUSRCLK21_IN;
    //------------- Transmit Ports - TX Driver and OOB signalling --------------
    output          TILE0_TXN0_OUT;
    output          TILE0_TXN1_OUT;
    output          TILE0_TXP0_OUT;
    output          TILE0_TXP1_OUT;





//***************************** Wire Declarations *****************************

    // Channel Bonding Signals


    // ground and vcc signals
    wire            tied_to_ground_i;
    wire    [63:0]  tied_to_ground_vec_i;
    wire            tied_to_vcc_i;
    wire    [63:0]  tied_to_vcc_vec_i;
    
//********************************* Main Body of Code**************************

    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 64'hffffffffffffffff;
    

    //------------------------- Tile Instances  -------------------------------   



    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE0  (Location)

    ROCKETIO_WRAPPER_GTX_TILE #
    (
        // Simulation attributes
        .TILE_SIM_GTXRESET_SPEEDUP   (WRAPPER_SIM_GTXRESET_SPEEDUP),
        .TILE_SIM_PLL_PERDIV2        (WRAPPER_SIM_PLL_PERDIV2),

        // Channel bonding attributes
        .TILE_CHAN_BOND_MODE_0       ("OFF"),
        .TILE_CHAN_BOND_LEVEL_0      (0),
    
        .TILE_CHAN_BOND_MODE_1       ("OFF"),
        .TILE_CHAN_BOND_LEVEL_1      (0)          
    )
    tile0_rocketio_wrapper_gtx_i
    (
        //---------------------- Loopback and Powerdown Ports ----------------------
        .LOOPBACK0_IN                   (TILE0_LOOPBACK0_IN),
        .LOOPBACK1_IN                   (TILE0_LOOPBACK1_IN),
        .RXPOWERDOWN0_IN                (TILE0_RXPOWERDOWN0_IN),
        .TXPOWERDOWN0_IN                (TILE0_TXPOWERDOWN0_IN),
        .RXPOWERDOWN1_IN                (TILE0_RXPOWERDOWN1_IN),
        .TXPOWERDOWN1_IN                (TILE0_TXPOWERDOWN1_IN),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .RXCHARISCOMMA0_OUT             (TILE0_RXCHARISCOMMA0_OUT),
        .RXCHARISCOMMA1_OUT             (TILE0_RXCHARISCOMMA1_OUT),
        .RXCHARISK0_OUT                 (TILE0_RXCHARISK0_OUT),
        .RXCHARISK1_OUT                 (TILE0_RXCHARISK1_OUT),
        .RXDISPERR0_OUT                 (TILE0_RXDISPERR0_OUT),
        .RXDISPERR1_OUT                 (TILE0_RXDISPERR1_OUT),
        .RXNOTINTABLE0_OUT              (TILE0_RXNOTINTABLE0_OUT),
        .RXNOTINTABLE1_OUT              (TILE0_RXNOTINTABLE1_OUT),
        .RXRUNDISP0_OUT                 (TILE0_RXRUNDISP0_OUT),
        .RXRUNDISP1_OUT                 (TILE0_RXRUNDISP1_OUT),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .RXCLKCORCNT0_OUT               (TILE0_RXCLKCORCNT0_OUT),
        .RXCLKCORCNT1_OUT               (TILE0_RXCLKCORCNT1_OUT),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .RXENMCOMMAALIGN0_IN            (TILE0_RXENMCOMMAALIGN0_IN),
        .RXENMCOMMAALIGN1_IN            (TILE0_RXENMCOMMAALIGN1_IN),
        .RXENPCOMMAALIGN0_IN            (TILE0_RXENPCOMMAALIGN0_IN),
        .RXENPCOMMAALIGN1_IN            (TILE0_RXENPCOMMAALIGN1_IN),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .RXDATA0_OUT                    (TILE0_RXDATA0_OUT),
        .RXDATA1_OUT                    (TILE0_RXDATA1_OUT),
        .RXRECCLK0_OUT                  (TILE0_RXRECCLK0_OUT),
        .RXRECCLK1_OUT                  (TILE0_RXRECCLK1_OUT),
        .RXRESET0_IN                    (TILE0_RXRESET0_IN),
        .RXRESET1_IN                    (TILE0_RXRESET1_IN),
        .RXUSRCLK0_IN                   (TILE0_RXUSRCLK0_IN),
        .RXUSRCLK1_IN                   (TILE0_RXUSRCLK1_IN),
        .RXUSRCLK20_IN                  (TILE0_RXUSRCLK20_IN),
        .RXUSRCLK21_IN                  (TILE0_RXUSRCLK21_IN),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .RXELECIDLE0_OUT                (TILE0_RXELECIDLE0_OUT),
        .RXELECIDLE1_OUT                (TILE0_RXELECIDLE1_OUT),
        .RXN0_IN                        (TILE0_RXN0_IN),
        .RXN1_IN                        (TILE0_RXN1_IN),
        .RXP0_IN                        (TILE0_RXP0_IN),
        .RXP1_IN                        (TILE0_RXP1_IN),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .RXBUFRESET0_IN                 (TILE0_RXBUFRESET0_IN),
        .RXBUFRESET1_IN                 (TILE0_RXBUFRESET1_IN),
        .RXBUFSTATUS0_OUT               (TILE0_RXBUFSTATUS0_OUT),
        .RXBUFSTATUS1_OUT               (TILE0_RXBUFSTATUS1_OUT),
        //------------------- Shared Ports - Tile and PLL Ports --------------------
        .CLKIN_IN                       (TILE0_CLKIN_IN),
        .GTXRESET_IN                    (TILE0_GTXRESET_IN),
        .PLLLKDET_OUT                   (TILE0_PLLLKDET_OUT),
        .REFCLKOUT_OUT                  (TILE0_REFCLKOUT_OUT),
        .RESETDONE0_OUT                 (TILE0_RESETDONE0_OUT),
        .RESETDONE1_OUT                 (TILE0_RESETDONE1_OUT),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .TXCHARDISPMODE0_IN             (TILE0_TXCHARDISPMODE0_IN),
        .TXCHARDISPMODE1_IN             (TILE0_TXCHARDISPMODE1_IN),
        .TXCHARDISPVAL0_IN              (TILE0_TXCHARDISPVAL0_IN),
        .TXCHARDISPVAL1_IN              (TILE0_TXCHARDISPVAL1_IN),
        .TXCHARISK0_IN                  (TILE0_TXCHARISK0_IN),
        .TXCHARISK1_IN                  (TILE0_TXCHARISK1_IN),
        //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
        .TXBUFSTATUS0_OUT               (TILE0_TXBUFSTATUS0_OUT),
        .TXBUFSTATUS1_OUT               (TILE0_TXBUFSTATUS1_OUT),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA0_IN                     (TILE0_TXDATA0_IN),
        .TXDATA1_IN                     (TILE0_TXDATA1_IN),
        .TXOUTCLK0_OUT                  (TILE0_TXOUTCLK0_OUT),
        .TXOUTCLK1_OUT                  (TILE0_TXOUTCLK1_OUT),
        .TXRESET0_IN                    (TILE0_TXRESET0_IN),
        .TXRESET1_IN                    (TILE0_TXRESET1_IN),
        .TXUSRCLK0_IN                   (TILE0_TXUSRCLK0_IN),
        .TXUSRCLK1_IN                   (TILE0_TXUSRCLK1_IN),
        .TXUSRCLK20_IN                  (TILE0_TXUSRCLK20_IN),
        .TXUSRCLK21_IN                  (TILE0_TXUSRCLK21_IN),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TXN0_OUT                       (TILE0_TXN0_OUT),
        .TXN1_OUT                       (TILE0_TXN1_OUT),
        .TXP0_OUT                       (TILE0_TXP0_OUT),
        .TXP1_OUT                       (TILE0_TXP1_OUT)

    );

    
     
endmodule

