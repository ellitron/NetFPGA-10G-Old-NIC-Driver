////////////////////////////////////////////////////////////////////////
//
//  NetFPGA-10G http://www.netfpga.org
//
//  Module:
//          rocketio_wrapper.v
//
//  Description:
//          RocketIO wrapper with Lane reverse
//                 
//  Revision history:
//          2010/12/8 hyzeng: Initial check-in
//
////////////////////////////////////////////////////////////////////////



`timescale 1ns / 1ps


//***************************** Entity Declaration ****************************

module ROCKETIO_WRAPPER #
(
    // Simulation attributes
    parameter   WRAPPER_SIM_MODE            = "FAST",   // Set to Fast Functional Simulation Model
    parameter   WRAPPER_SIM_GTXRESET_SPEEDUP    = 0,    // Set to 1 to speed up sim reset
    parameter   WRAPPER_SIM_PLL_PERDIV2         = 9'h140,   // Set to the VCO Unit Interval time
    parameter   REVERSE_LANES                   = 0 
)
(

    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE0  (Location)

    //---------------------- Loopback and Powerdown Ports ----------------------
    TILE0_LOOPBACK0_IN,
    TILE0_LOOPBACK1_IN,
    TILE0_RXPOWERDOWN0_IN,
    TILE0_RXPOWERDOWN1_IN,
    TILE0_TXPOWERDOWN0_IN,
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
    //----------------- Receive Ports - Channel Bonding Ports ------------------
    TILE0_RXCHANBONDSEQ0_OUT,
    TILE0_RXCHANBONDSEQ1_OUT,
    TILE0_RXENCHANSYNC0_IN,
    TILE0_RXENCHANSYNC1_IN,
    //----------------- Receive Ports - Clock Correction Ports -----------------
    TILE0_RXCLKCORCNT0_OUT,
    TILE0_RXCLKCORCNT1_OUT,
    //------------- Receive Ports - Comma Detection and Alignment --------------
    TILE0_RXBYTEISALIGNED0_OUT,
    TILE0_RXBYTEISALIGNED1_OUT,
    TILE0_RXBYTEREALIGN0_OUT,
    TILE0_RXBYTEREALIGN1_OUT,
    TILE0_RXCOMMADET0_OUT,
    TILE0_RXCOMMADET1_OUT,
    TILE0_RXENMCOMMAALIGN0_IN,
    TILE0_RXENMCOMMAALIGN1_IN,
    TILE0_RXENPCOMMAALIGN0_IN,
    TILE0_RXENPCOMMAALIGN1_IN,
    //----------------- Receive Ports - RX Data Path interface -----------------
    TILE0_RXDATA0_OUT,
    TILE0_RXDATA1_OUT,
    TILE0_RXRESET0_IN,
    TILE0_RXRESET1_IN,
    TILE0_RXUSRCLK0_IN,
    TILE0_RXUSRCLK1_IN,
    TILE0_RXUSRCLK20_IN,
    TILE0_RXUSRCLK21_IN,
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    TILE0_RXCDRRESET0_IN,
    TILE0_RXCDRRESET1_IN,
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
    TILE0_RXCHANISALIGNED0_OUT,
    TILE0_RXCHANISALIGNED1_OUT,
    TILE0_RXCHANREALIGN0_OUT,
    TILE0_RXCHANREALIGN1_OUT,
    //------------- Receive Ports - RX Loss-of-sync State Machine --------------
    TILE0_RXLOSSOFSYNC0_OUT,
    TILE0_RXLOSSOFSYNC1_OUT,
    //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    TILE0_DADDR_IN,
    TILE0_DCLK_IN,
    TILE0_DEN_IN,
    TILE0_DI_IN,
    TILE0_DO_OUT,
    TILE0_DRDY_OUT,
    TILE0_DWE_IN,
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    TILE0_CLKIN_IN,
    TILE0_GTXRESET_IN,
    TILE0_PLLLKDET_OUT,
    TILE0_REFCLKOUT_OUT,
    TILE0_RESETDONE0_OUT,
    TILE0_RESETDONE1_OUT,
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    TILE0_TXCHARISK0_IN,
    TILE0_TXCHARISK1_IN,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    TILE0_TXDATA0_IN,
    TILE0_TXDATA1_IN,
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
    TILE0_TXP1_OUT,
     
    //------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    TILE0_TXENPMAPHASEALIGN0_IN,
    TILE0_TXENPMAPHASEALIGN1_IN,
    TILE0_TXPMASETPHASE0_IN,
    TILE0_TXPMASETPHASE1_IN,
    //--------------- Transmit Ports - TX Ports for PCI Express ----------------
    TILE0_TXELECIDLE0_IN,
    TILE0_TXELECIDLE1_IN,


    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE1  (Location)

    //---------------------- Loopback and Powerdown Ports ----------------------
    TILE1_LOOPBACK0_IN,
    TILE1_LOOPBACK1_IN,
    TILE1_RXPOWERDOWN0_IN,
    TILE1_RXPOWERDOWN1_IN,
    TILE1_TXPOWERDOWN0_IN,
    TILE1_TXPOWERDOWN1_IN,
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    TILE1_RXCHARISCOMMA0_OUT,
    TILE1_RXCHARISCOMMA1_OUT,
    TILE1_RXCHARISK0_OUT,
    TILE1_RXCHARISK1_OUT,
    TILE1_RXDISPERR0_OUT,
    TILE1_RXDISPERR1_OUT,
    TILE1_RXNOTINTABLE0_OUT,
    TILE1_RXNOTINTABLE1_OUT,
    //----------------- Receive Ports - Channel Bonding Ports ------------------
    TILE1_RXCHANBONDSEQ0_OUT,
    TILE1_RXCHANBONDSEQ1_OUT,
    TILE1_RXENCHANSYNC0_IN,
    TILE1_RXENCHANSYNC1_IN,
    //----------------- Receive Ports - Clock Correction Ports -----------------
    TILE1_RXCLKCORCNT0_OUT,
    TILE1_RXCLKCORCNT1_OUT,
    //------------- Receive Ports - Comma Detection and Alignment --------------
    TILE1_RXBYTEISALIGNED0_OUT,
    TILE1_RXBYTEISALIGNED1_OUT,
    TILE1_RXBYTEREALIGN0_OUT,
    TILE1_RXBYTEREALIGN1_OUT,
    TILE1_RXCOMMADET0_OUT,
    TILE1_RXCOMMADET1_OUT,
    TILE1_RXENMCOMMAALIGN0_IN,
    TILE1_RXENMCOMMAALIGN1_IN,
    TILE1_RXENPCOMMAALIGN0_IN,
    TILE1_RXENPCOMMAALIGN1_IN,
    //----------------- Receive Ports - RX Data Path interface -----------------
    TILE1_RXDATA0_OUT,
    TILE1_RXDATA1_OUT,
    TILE1_RXRESET0_IN,
    TILE1_RXRESET1_IN,
    TILE1_RXUSRCLK0_IN,
    TILE1_RXUSRCLK1_IN,
    TILE1_RXUSRCLK20_IN,
    TILE1_RXUSRCLK21_IN,
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    TILE1_RXCDRRESET0_IN,
    TILE1_RXCDRRESET1_IN,
    TILE1_RXELECIDLE0_OUT,
    TILE1_RXELECIDLE1_OUT,
    TILE1_RXN0_IN,
    TILE1_RXN1_IN,
    TILE1_RXP0_IN,
    TILE1_RXP1_IN,
    //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    TILE1_RXBUFRESET0_IN,
    TILE1_RXBUFRESET1_IN,
    TILE1_RXBUFSTATUS0_OUT,
    TILE1_RXBUFSTATUS1_OUT,
    TILE1_RXCHANISALIGNED0_OUT,
    TILE1_RXCHANISALIGNED1_OUT,
    TILE1_RXCHANREALIGN0_OUT,
    TILE1_RXCHANREALIGN1_OUT,
    //------------- Receive Ports - RX Loss-of-sync State Machine --------------
    TILE1_RXLOSSOFSYNC0_OUT,
    TILE1_RXLOSSOFSYNC1_OUT,
    //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    TILE1_DADDR_IN,
    TILE1_DCLK_IN,
    TILE1_DEN_IN,
    TILE1_DI_IN,
    TILE1_DO_OUT,
    TILE1_DRDY_OUT,
    TILE1_DWE_IN,
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    TILE1_CLKIN_IN,
    TILE1_GTXRESET_IN,
    TILE1_PLLLKDET_OUT,
    TILE1_REFCLKOUT_OUT,
    TILE1_RESETDONE0_OUT,
    TILE1_RESETDONE1_OUT,
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    TILE1_TXCHARISK0_IN,
    TILE1_TXCHARISK1_IN,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    TILE1_TXDATA0_IN,
    TILE1_TXDATA1_IN,
    TILE1_TXRESET0_IN,
    TILE1_TXRESET1_IN,
    TILE1_TXUSRCLK0_IN,
    TILE1_TXUSRCLK1_IN,
    TILE1_TXUSRCLK20_IN,
    TILE1_TXUSRCLK21_IN,
    //------------- Transmit Ports - TX Driver and OOB signalling --------------
        
    TILE1_TXN0_OUT,
    TILE1_TXN1_OUT,
    TILE1_TXP0_OUT,
    TILE1_TXP1_OUT,
      
    //------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    TILE1_TXENPMAPHASEALIGN0_IN,
    TILE1_TXENPMAPHASEALIGN1_IN,
    TILE1_TXPMASETPHASE0_IN,
    TILE1_TXPMASETPHASE1_IN,
    //--------------- Transmit Ports - TX Ports for PCI Express ----------------
    TILE1_TXELECIDLE0_IN,
    TILE1_TXELECIDLE1_IN

);

//synthesis attribute X_CORE_INFO of ROCKETIO_WRAPPER is "gtxwizard_v1_6, Coregen v11.2";

//***************************** Port Declarations *****************************



    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE0  (Location)

    //---------------------- Loopback and Powerdown Ports ----------------------
    input   [2:0]   TILE0_LOOPBACK0_IN;
    input   [2:0]   TILE0_LOOPBACK1_IN;
    input   [1:0]   TILE0_RXPOWERDOWN0_IN;
    input   [1:0]   TILE0_RXPOWERDOWN1_IN;
    input   [1:0]   TILE0_TXPOWERDOWN0_IN;
    input   [1:0]   TILE0_TXPOWERDOWN1_IN;
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    output  [1:0]   TILE0_RXCHARISCOMMA0_OUT;
    output  [1:0]   TILE0_RXCHARISCOMMA1_OUT;
    output  [1:0]   TILE0_RXCHARISK0_OUT;
    output  [1:0]   TILE0_RXCHARISK1_OUT;
    output  [1:0]   TILE0_RXDISPERR0_OUT;
    output  [1:0]   TILE0_RXDISPERR1_OUT;
    output  [1:0]   TILE0_RXNOTINTABLE0_OUT;
    output  [1:0]   TILE0_RXNOTINTABLE1_OUT;
    //----------------- Receive Ports - Channel Bonding Ports ------------------
    output          TILE0_RXCHANBONDSEQ0_OUT;
    output          TILE0_RXCHANBONDSEQ1_OUT;
    input           TILE0_RXENCHANSYNC0_IN;
    input           TILE0_RXENCHANSYNC1_IN;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    output  [2:0]   TILE0_RXCLKCORCNT0_OUT;
    output  [2:0]   TILE0_RXCLKCORCNT1_OUT;
    //------------- Receive Ports - Comma Detection and Alignment --------------
    output          TILE0_RXBYTEISALIGNED0_OUT;
    output          TILE0_RXBYTEISALIGNED1_OUT;
    output          TILE0_RXBYTEREALIGN0_OUT;
    output          TILE0_RXBYTEREALIGN1_OUT;
    output          TILE0_RXCOMMADET0_OUT;
    output          TILE0_RXCOMMADET1_OUT;
    input           TILE0_RXENMCOMMAALIGN0_IN;
    input           TILE0_RXENMCOMMAALIGN1_IN;
    input           TILE0_RXENPCOMMAALIGN0_IN;
    input           TILE0_RXENPCOMMAALIGN1_IN;
    //----------------- Receive Ports - RX Data Path interface -----------------
    output  [15:0]  TILE0_RXDATA0_OUT;
    output  [15:0]  TILE0_RXDATA1_OUT;
    input           TILE0_RXRESET0_IN;
    input           TILE0_RXRESET1_IN;
    input           TILE0_RXUSRCLK0_IN;
    input           TILE0_RXUSRCLK1_IN;
    input           TILE0_RXUSRCLK20_IN;
    input           TILE0_RXUSRCLK21_IN;
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    input           TILE0_RXCDRRESET0_IN;
    input           TILE0_RXCDRRESET1_IN;
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
    output          TILE0_RXCHANISALIGNED0_OUT;
    output          TILE0_RXCHANISALIGNED1_OUT;
    output          TILE0_RXCHANREALIGN0_OUT;
    output          TILE0_RXCHANREALIGN1_OUT;
    //------------- Receive Ports - RX Loss-of-sync State Machine --------------
    output  [1:0]   TILE0_RXLOSSOFSYNC0_OUT;
    output  [1:0]   TILE0_RXLOSSOFSYNC1_OUT;
    //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    input   [6:0]   TILE0_DADDR_IN;
    input           TILE0_DCLK_IN;
    input           TILE0_DEN_IN;
    input   [15:0]  TILE0_DI_IN;
    output  [15:0]  TILE0_DO_OUT;
    output          TILE0_DRDY_OUT;
    input           TILE0_DWE_IN;
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    input           TILE0_CLKIN_IN;
    input           TILE0_GTXRESET_IN;
    output          TILE0_PLLLKDET_OUT;
    output          TILE0_REFCLKOUT_OUT;
    output          TILE0_RESETDONE0_OUT;
    output          TILE0_RESETDONE1_OUT;
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    input   [1:0]   TILE0_TXCHARISK0_IN;
    input   [1:0]   TILE0_TXCHARISK1_IN;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input   [15:0]  TILE0_TXDATA0_IN;
    input   [15:0]  TILE0_TXDATA1_IN;
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
      
    //------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    input           TILE0_TXENPMAPHASEALIGN0_IN;
    input           TILE0_TXENPMAPHASEALIGN1_IN;
    input           TILE0_TXPMASETPHASE0_IN;
    input           TILE0_TXPMASETPHASE1_IN;
    //--------------- Transmit Ports - TX Ports for PCI Express ----------------
    input           TILE0_TXELECIDLE0_IN;
    input           TILE0_TXELECIDLE1_IN;

    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE1  (Location)

    //---------------------- Loopback and Powerdown Ports ----------------------
    input   [2:0]   TILE1_LOOPBACK0_IN;
    input   [2:0]   TILE1_LOOPBACK1_IN;
    input   [1:0]   TILE1_RXPOWERDOWN0_IN;
    input   [1:0]   TILE1_RXPOWERDOWN1_IN;
    input   [1:0]   TILE1_TXPOWERDOWN0_IN;
    input   [1:0]   TILE1_TXPOWERDOWN1_IN;
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    output  [1:0]   TILE1_RXCHARISCOMMA0_OUT;
    output  [1:0]   TILE1_RXCHARISCOMMA1_OUT;
    output  [1:0]   TILE1_RXCHARISK0_OUT;
    output  [1:0]   TILE1_RXCHARISK1_OUT;
    output  [1:0]   TILE1_RXDISPERR0_OUT;
    output  [1:0]   TILE1_RXDISPERR1_OUT;
    output  [1:0]   TILE1_RXNOTINTABLE0_OUT;
    output  [1:0]   TILE1_RXNOTINTABLE1_OUT;
    //----------------- Receive Ports - Channel Bonding Ports ------------------
    output          TILE1_RXCHANBONDSEQ0_OUT;
    output          TILE1_RXCHANBONDSEQ1_OUT;
    input           TILE1_RXENCHANSYNC0_IN;
    input           TILE1_RXENCHANSYNC1_IN;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    output  [2:0]   TILE1_RXCLKCORCNT0_OUT;
    output  [2:0]   TILE1_RXCLKCORCNT1_OUT;
    //------------- Receive Ports - Comma Detection and Alignment --------------
    output          TILE1_RXBYTEISALIGNED0_OUT;
    output          TILE1_RXBYTEISALIGNED1_OUT;
    output          TILE1_RXBYTEREALIGN0_OUT;
    output          TILE1_RXBYTEREALIGN1_OUT;
    output          TILE1_RXCOMMADET0_OUT;
    output          TILE1_RXCOMMADET1_OUT;
    input           TILE1_RXENMCOMMAALIGN0_IN;
    input           TILE1_RXENMCOMMAALIGN1_IN;
    input           TILE1_RXENPCOMMAALIGN0_IN;
    input           TILE1_RXENPCOMMAALIGN1_IN;
    //----------------- Receive Ports - RX Data Path interface -----------------
    output  [15:0]  TILE1_RXDATA0_OUT;
    output  [15:0]  TILE1_RXDATA1_OUT;
    input           TILE1_RXRESET0_IN;
    input           TILE1_RXRESET1_IN;
    input           TILE1_RXUSRCLK0_IN;
    input           TILE1_RXUSRCLK1_IN;
    input           TILE1_RXUSRCLK20_IN;
    input           TILE1_RXUSRCLK21_IN;
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    input           TILE1_RXCDRRESET0_IN;
    input           TILE1_RXCDRRESET1_IN;
    output          TILE1_RXELECIDLE0_OUT;
    output          TILE1_RXELECIDLE1_OUT;
    input           TILE1_RXN0_IN;
    input           TILE1_RXN1_IN;
    input           TILE1_RXP0_IN;
    input           TILE1_RXP1_IN;
    //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    input           TILE1_RXBUFRESET0_IN;
    input           TILE1_RXBUFRESET1_IN;
    output  [2:0]   TILE1_RXBUFSTATUS0_OUT;
    output  [2:0]   TILE1_RXBUFSTATUS1_OUT;
    output          TILE1_RXCHANISALIGNED0_OUT;
    output          TILE1_RXCHANISALIGNED1_OUT;
    output          TILE1_RXCHANREALIGN0_OUT;
    output          TILE1_RXCHANREALIGN1_OUT;
    //------------- Receive Ports - RX Loss-of-sync State Machine --------------
    output  [1:0]   TILE1_RXLOSSOFSYNC0_OUT;
    output  [1:0]   TILE1_RXLOSSOFSYNC1_OUT;
    //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    input   [6:0]   TILE1_DADDR_IN;
    input           TILE1_DCLK_IN;
    input           TILE1_DEN_IN;
    input   [15:0]  TILE1_DI_IN;
    output  [15:0]  TILE1_DO_OUT;
    output          TILE1_DRDY_OUT;
    input           TILE1_DWE_IN;
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    input           TILE1_CLKIN_IN;
    input           TILE1_GTXRESET_IN;
    output          TILE1_PLLLKDET_OUT;
    output          TILE1_REFCLKOUT_OUT;
    output          TILE1_RESETDONE0_OUT;
    output          TILE1_RESETDONE1_OUT;
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    input   [1:0]   TILE1_TXCHARISK0_IN;
    input   [1:0]   TILE1_TXCHARISK1_IN;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input   [15:0]  TILE1_TXDATA0_IN;
    input   [15:0]  TILE1_TXDATA1_IN;
    input           TILE1_TXRESET0_IN;
    input           TILE1_TXRESET1_IN;
    input           TILE1_TXUSRCLK0_IN;
    input           TILE1_TXUSRCLK1_IN;
    input           TILE1_TXUSRCLK20_IN;
    input           TILE1_TXUSRCLK21_IN;
    //------------- Transmit Ports - TX Driver and OOB signalling --------------
              
    output          TILE1_TXN0_OUT;
    output          TILE1_TXN1_OUT;
    output          TILE1_TXP0_OUT;
    output          TILE1_TXP1_OUT;
       
    //------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    input           TILE1_TXENPMAPHASEALIGN0_IN;
    input           TILE1_TXENPMAPHASEALIGN1_IN;
    input           TILE1_TXPMASETPHASE0_IN;
    input           TILE1_TXPMASETPHASE1_IN;
    //--------------- Transmit Ports - TX Ports for PCI Express ----------------
    input           TILE1_TXELECIDLE0_IN;
    input           TILE1_TXELECIDLE1_IN;


//***************************** Wire Declarations *****************************

    // Channel Bonding Signals
    wire    [3:0]   tile0_rxchbondo0_i;
    wire    [3:0]   tile0_rxchbondo1_i;

    // 
    wire    [15:0]  tile0_rxdata0_i;
    wire    [1:0]   tile0_rxcharisk0_i;
    wire    [1:0]   tile0_rxchariscomma0_i;
    wire    [1:0]   tile0_rxrundisp0_i;
    wire    [1:0]   tile0_rxnotintable0_i;
    wire    [1:0]   tile0_rxdisperr0_i;
    wire    [2:0]   tile0_rxbufstatus0_i;
    wire    [2:0]   tile0_rxclkcorcnt0_i;
    wire            tile0_rxchanbondseq0_i;
    wire            tile0_rxchanisaligned0_i;
    wire            tile0_rxchanrealign0_i;
    wire    [1:0]   tile0_rxlossofsync0_i;
    wire            tile0_rxvalid0_i;
    wire            tile0_rxrecclk0_i;
    wire            tile0_resetdone0_i;
    wire            tile0_rxreset0_i;
    wire            tile0_rxbufreset0_i;
    
    wire    [15:0]  tile0_rxdata1_i;
    wire    [1:0]   tile0_rxcharisk1_i;
    wire    [1:0]   tile0_rxchariscomma1_i;
    wire    [1:0]   tile0_rxrundisp1_i;
    wire    [1:0]   tile0_rxnotintable1_i;
    wire    [1:0]   tile0_rxdisperr1_i;
    wire    [2:0]   tile0_rxbufstatus1_i;
    wire    [2:0]   tile0_rxclkcorcnt1_i;
    wire            tile0_rxchanbondseq1_i;
    wire            tile0_rxchanisaligned1_i;
    wire            tile0_rxchanrealign1_i;
    wire    [1:0]   tile0_rxlossofsync1_i;
    wire            tile0_rxvalid1_i;
    wire            tile0_rxrecclk1_i;
    wire            tile0_resetdone1_i;
    wire            tile0_rxreset1_i;
    wire            tile0_rxbufreset1_i;
    

    wire    [3:0]   tile1_rxchbondo0_i;
    wire    [3:0]   tile1_rxchbondo1_i;

    // 
    wire    [15:0]  tile1_rxdata0_i;
    wire    [1:0]   tile1_rxcharisk0_i;
    wire    [1:0]   tile1_rxchariscomma0_i;
    wire    [1:0]   tile1_rxrundisp0_i;
    wire    [1:0]   tile1_rxnotintable0_i;
    wire    [1:0]   tile1_rxdisperr0_i;
    wire    [2:0]   tile1_rxbufstatus0_i;
    wire    [2:0]   tile1_rxclkcorcnt0_i;
    wire            tile1_rxchanbondseq0_i;
    wire            tile1_rxchanisaligned0_i;
    wire            tile1_rxchanrealign0_i;
    wire    [1:0]   tile1_rxlossofsync0_i;
    wire            tile1_rxvalid0_i;
    wire            tile1_rxrecclk0_i;
    wire            tile1_resetdone0_i;
    wire            tile1_gtp0_cc_2b_1skp_reset_i;
    wire            tile1_rxreset0_i;
    wire            tile1_rxbufreset0_i;
    
    wire    [15:0]  tile1_rxdata1_i;
    wire    [1:0]   tile1_rxcharisk1_i;
    wire    [1:0]   tile1_rxchariscomma1_i;
    wire    [1:0]   tile1_rxrundisp1_i;
    wire    [1:0]   tile1_rxnotintable1_i;
    wire    [1:0]   tile1_rxdisperr1_i;
    wire    [2:0]   tile1_rxbufstatus1_i;
    wire    [2:0]   tile1_rxclkcorcnt1_i;
    wire            tile1_rxchanbondseq1_i;
    wire            tile1_rxchanisaligned1_i;
    wire            tile1_rxchanrealign1_i;
    wire    [1:0]   tile1_rxlossofsync1_i;
    wire            tile1_rxvalid1_i;
    wire            tile1_rxrecclk1_i;
    wire            tile1_resetdone1_i;
    wire            tile1_rxreset1_i;
    wire            tile1_rxbufreset1_i;
    

    wire    [6:0]   tile1_gtp0_cc_2b_1skp_cco_i;

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

    ROCKETIO_WRAPPER_TILE #
    (
        // Simulation attributes
        .TILE_SIM_MODE               (WRAPPER_SIM_MODE),
        .TILE_SIM_GTXRESET_SPEEDUP   (WRAPPER_SIM_GTXRESET_SPEEDUP),
        .TILE_SIM_PLL_PERDIV2        (WRAPPER_SIM_PLL_PERDIV2),

        // Channel bonding attributes
        .TILE_CHAN_BOND_MODE_0       ("SLAVE"),
        .TILE_CHAN_BOND_LEVEL_0      (0),

        .TILE_CHAN_BOND_MODE_1       ("SLAVE"),
        .TILE_CHAN_BOND_LEVEL_1      (0),
        
        .REVERSE_LANES               (REVERSE_LANES) 
    )
    tile0_rocketio_wrapper_i
    (
        //---------------------- Loopback and Powerdown Ports ----------------------
        .LOOPBACK0_IN                   (TILE0_LOOPBACK0_IN),
        .LOOPBACK1_IN                   (TILE0_LOOPBACK1_IN),
        .RXPOWERDOWN0_IN                (TILE0_RXPOWERDOWN0_IN),
        .RXPOWERDOWN1_IN                (TILE0_RXPOWERDOWN1_IN),
        .TXPOWERDOWN0_IN                (TILE0_TXPOWERDOWN0_IN),
        .TXPOWERDOWN1_IN                (TILE0_TXPOWERDOWN1_IN),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .RXCHARISCOMMA0_OUT             (tile0_rxchariscomma0_i),
        .RXCHARISCOMMA1_OUT             (tile0_rxchariscomma1_i),
        .RXCHARISK0_OUT                 (tile0_rxcharisk0_i),
        .RXCHARISK1_OUT                 (tile0_rxcharisk1_i),
        .RXDISPERR0_OUT                 (tile0_rxdisperr0_i),
        .RXDISPERR1_OUT                 (tile0_rxdisperr1_i),
        .RXNOTINTABLE0_OUT              (tile0_rxnotintable0_i),
        .RXNOTINTABLE1_OUT              (tile0_rxnotintable1_i),
        .RXRUNDISP0_OUT                 (tile0_rxrundisp0_i),
        .RXRUNDISP1_OUT                 (tile0_rxrundisp1_i),
        //----------------- Receive Ports - Channel Bonding Ports ------------------
        .RXCHANBONDSEQ0_OUT             (tile0_rxchanbondseq0_i),
        .RXCHANBONDSEQ1_OUT             (tile0_rxchanbondseq1_i),
        .RXCHBONDI0_IN                  (tile1_rxchbondo1_i),
        .RXCHBONDI1_IN                  (tile1_rxchbondo1_i),
        .RXCHBONDO0_OUT                 (tile0_rxchbondo0_i),
        .RXCHBONDO1_OUT                 (tile0_rxchbondo1_i),
        .RXENCHANSYNC0_IN               (TILE0_RXENCHANSYNC0_IN),
        .RXENCHANSYNC1_IN               (TILE0_RXENCHANSYNC1_IN),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .RXCLKCORCNT0_OUT               (tile0_rxclkcorcnt0_i),
        .RXCLKCORCNT1_OUT               (tile0_rxclkcorcnt1_i),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .RXBYTEISALIGNED0_OUT           (TILE0_RXBYTEISALIGNED0_OUT),
        .RXBYTEISALIGNED1_OUT           (TILE0_RXBYTEISALIGNED1_OUT),
        .RXBYTEREALIGN0_OUT             (TILE0_RXBYTEREALIGN0_OUT),
        .RXBYTEREALIGN1_OUT             (TILE0_RXBYTEREALIGN1_OUT),
        .RXCOMMADET0_OUT                (TILE0_RXCOMMADET0_OUT),
        .RXCOMMADET1_OUT                (TILE0_RXCOMMADET1_OUT),
        .RXENMCOMMAALIGN0_IN            (TILE0_RXENMCOMMAALIGN0_IN),
        .RXENMCOMMAALIGN1_IN            (TILE0_RXENMCOMMAALIGN1_IN),
        .RXENPCOMMAALIGN0_IN            (TILE0_RXENPCOMMAALIGN0_IN),
        .RXENPCOMMAALIGN1_IN            (TILE0_RXENPCOMMAALIGN1_IN),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .RXDATA0_OUT                    (tile0_rxdata0_i),
        .RXDATA1_OUT                    (tile0_rxdata1_i),
        .RXRECCLK0_OUT                  (tile0_rxrecclk0_i),
        .RXRECCLK1_OUT                  (tile0_rxrecclk1_i),
        .RXRESET0_IN                    (tile0_rxreset0_i),
        .RXRESET1_IN                    (tile0_rxreset1_i),
        .RXUSRCLK0_IN                   (tile1_rxrecclk0_bufg_i),
        .RXUSRCLK1_IN                   (tile1_rxrecclk0_bufg_i),
        .RXUSRCLK20_IN                  (tile1_rxrecclk0_bufg_i),
        .RXUSRCLK21_IN                  (tile1_rxrecclk0_bufg_i),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .RXCDRRESET0_IN                 (TILE0_RXCDRRESET0_IN),
        .RXCDRRESET1_IN                 (TILE0_RXCDRRESET1_IN),
        .RXELECIDLE0_OUT                (TILE0_RXELECIDLE0_OUT),
        .RXELECIDLE1_OUT                (TILE0_RXELECIDLE1_OUT),
        .RXN0_IN                        (TILE0_RXN0_IN),
        .RXN1_IN                        (TILE0_RXN1_IN),
        .RXP0_IN                        (TILE0_RXP0_IN),
        .RXP1_IN                        (TILE0_RXP1_IN),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .RXBUFRESET0_IN                 (tile0_rxbufreset0_i),
        .RXBUFRESET1_IN                 (tile0_rxbufreset1_i),
        .RXBUFSTATUS0_OUT               (tile0_rxbufstatus0_i),
        .RXBUFSTATUS1_OUT               (tile0_rxbufstatus1_i),
        .RXCHANISALIGNED0_OUT           (tile0_rxchanisaligned0_i),
        .RXCHANISALIGNED1_OUT           (tile0_rxchanisaligned1_i),
        .RXCHANREALIGN0_OUT             (tile0_rxchanrealign0_i),
        .RXCHANREALIGN1_OUT             (tile0_rxchanrealign1_i),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .RXLOSSOFSYNC0_OUT              (tile0_rxlossofsync0_i),
        .RXLOSSOFSYNC1_OUT              (tile0_rxlossofsync1_i),
        //------------ Receive Ports - RX Pipe Control for PCI Express -------------
        .RXVALID0_OUT                   (tile0_rxvalid0_i),
        .RXVALID1_OUT                   (tile0_rxvalid1_i),
        //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
        .DADDR_IN                       (TILE0_DADDR_IN),
        .DCLK_IN                        (TILE0_DCLK_IN),
        .DEN_IN                         (TILE0_DEN_IN),
        .DI_IN                          (TILE0_DI_IN),
        .DO_OUT                         (TILE0_DO_OUT),
        .DRDY_OUT                       (TILE0_DRDY_OUT),
        .DWE_IN                         (TILE0_DWE_IN),
        //------------------- Shared Ports - Tile and PLL Ports --------------------
        .CLKIN_IN                       (TILE0_CLKIN_IN),
        .GTXRESET_IN                    (TILE0_GTXRESET_IN),
        .PLLLKDET_OUT                   (TILE0_PLLLKDET_OUT),
        .REFCLKOUT_OUT                  (TILE0_REFCLKOUT_OUT),
        .RESETDONE0_OUT                 (tile0_resetdone0_i),
        .RESETDONE1_OUT                 (tile0_resetdone1_i),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .TXCHARISK0_IN                  (TILE0_TXCHARISK0_IN),
        .TXCHARISK1_IN                  (TILE0_TXCHARISK1_IN),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA0_IN                     (TILE0_TXDATA0_IN),
        .TXDATA1_IN                     (TILE0_TXDATA1_IN),
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
        .TXP1_OUT                       (TILE0_TXP1_OUT),
 
        //------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .TXENPMAPHASEALIGN0_IN          (TILE0_TXENPMAPHASEALIGN0_IN),
        .TXENPMAPHASEALIGN1_IN          (TILE0_TXENPMAPHASEALIGN1_IN),
        .TXPMASETPHASE0_IN              (TILE0_TXPMASETPHASE0_IN),
        .TXPMASETPHASE1_IN              (TILE0_TXPMASETPHASE1_IN),
        //--------------- Transmit Ports - TX Ports for PCI Express ----------------
        .TXELECIDLE0_IN                 (TILE0_TXELECIDLE0_IN),
        .TXELECIDLE1_IN                 (TILE0_TXELECIDLE1_IN)
    );

    //_________________________________________________________________________
    //_________________________________________________________________________   
    //TILE0 GTP0
    CC_2B_1SKP #(
        .CC_CHAR                  (8'h1C),     // CC character
        .ALIGN_CHAR               (8'h7C),     // Alignment character
        .CHAN_BOND_MODE           ("SLAVE"),     // "MASTER", "OFF", "SLAVE"
        .ALIGN_PARALLEL_CHECK     (1'b1)  // Check alignment in parallel data
    ) tile0_gtp0_cc_2b_1skp_i (
        // Write Interface on the RXRECCLK
        .GT_RXDATA                (tile0_rxdata0_i),
        .GT_RXCHARISK             (tile0_rxcharisk0_i),
        .GT_RXCHARISCOMMA         (tile0_rxchariscomma0_i),
        .GT_RXRUNDISP             (tile0_rxrundisp0_i),
        .GT_RXNOTINTABLE          (tile0_rxnotintable0_i),
        .GT_RXDISPERR             (tile0_rxdisperr0_i),
        .GT_RXBUFSTATUS           (tile0_rxbufstatus0_i),
        .GT_RXCLKCORCNT           (tile0_rxclkcorcnt0_i),
        .GT_RXCHANBONDSEQ         (tile0_rxchanbondseq0_i),
        .GT_RXCHANISALIGNED       (tile0_rxchanisaligned0_i),
        .GT_RXCHANREALIGN         (tile0_rxchanrealign0_i),
        .GT_RXLOSSOFSYNC          (tile0_rxlossofsync0_i),
        .GT_RXVALID               (tile0_rxvalid0_i),
        .GT_RXUSRCLK2             (tile1_rxrecclk0_bufg_i),
    
        // Read Interface on the RXUSRCLK2
        .USER_RXDATA              (TILE0_RXDATA0_OUT),
        .USER_RXCHARISK           (TILE0_RXCHARISK0_OUT),
        .USER_RXCHARISCOMMA       (TILE0_RXCHARISCOMMA0_OUT),
        .USER_RXRUNDISP           (),
        .USER_RXNOTINTABLE        (TILE0_RXNOTINTABLE0_OUT),
        .USER_RXDISPERR           (TILE0_RXDISPERR0_OUT),
        .USER_RXBUFSTATUS         (TILE0_RXBUFSTATUS0_OUT),
        .USER_RXCLKCORCNT         (TILE0_RXCLKCORCNT0_OUT),
        .USER_RXCHANBONDSEQ       (TILE0_RXCHANBONDSEQ0_OUT),
        .USER_RXCHANISALIGNED     (TILE0_RXCHANISALIGNED0_OUT),
        .USER_RXCHANREALIGN       (TILE0_RXCHANREALIGN0_OUT),
        .USER_RXLOSSOFSYNC        (TILE0_RXLOSSOFSYNC0_OUT),
        .USER_RXVALID             (),
        .USER_RXUSRCLK2           (TILE0_RXUSRCLK20_IN),
    
        // Status and reset signals
        .RESET                    (tied_to_ground_i), // I
        .CCI                      (tile1_gtp0_cc_2b_1skp_cco_i), // I [6:0] - Connect to Master output
        .CCO                      ()  // O [6:0] - Connect to Slave input
    );



    assign TILE0_RESETDONE0_OUT = tile0_resetdone0_i;
    assign tile0_rxreset0_i = TILE0_RXRESET0_IN;
    assign tile0_rxbufreset0_i = TILE0_RXBUFRESET0_IN;


    //_________________________________________________________________________
    //_________________________________________________________________________   
    //TILE0 GTP1
    CC_2B_1SKP #(
        .CC_CHAR                  (8'h1C),     // CC character
        .ALIGN_CHAR               (8'h7C),     // Alignment character
        .CHAN_BOND_MODE           ("SLAVE"),     // "MASTER", "OFF", "SLAVE"
        .ALIGN_PARALLEL_CHECK     (1'b1)  // Check alignment in parallel data
    ) tile0_gtp1_cc_2b_1skp_i (
        // Write Interface on the RXRECCLK
        .GT_RXDATA                (tile0_rxdata1_i),
        .GT_RXCHARISK             (tile0_rxcharisk1_i),
        .GT_RXCHARISCOMMA         (tile0_rxchariscomma1_i),
        .GT_RXRUNDISP             (tile0_rxrundisp1_i),
        .GT_RXNOTINTABLE          (tile0_rxnotintable1_i),
        .GT_RXDISPERR             (tile0_rxdisperr1_i),
        .GT_RXBUFSTATUS           (tile0_rxbufstatus1_i),
        .GT_RXCLKCORCNT           (tile0_rxclkcorcnt1_i),
        .GT_RXCHANBONDSEQ         (tile0_rxchanbondseq1_i),
        .GT_RXCHANISALIGNED       (tile0_rxchanisaligned1_i),
        .GT_RXCHANREALIGN         (tile0_rxchanrealign1_i),
        .GT_RXLOSSOFSYNC          (tile0_rxlossofsync1_i),
        .GT_RXVALID               (tile0_rxvalid1_i),
        .GT_RXUSRCLK2             (tile1_rxrecclk0_bufg_i),
    
        // Read Interface on the RXUSRCLK2
        .USER_RXDATA              (TILE0_RXDATA1_OUT),
        .USER_RXCHARISK           (TILE0_RXCHARISK1_OUT),
        .USER_RXCHARISCOMMA       (TILE0_RXCHARISCOMMA1_OUT),
        .USER_RXRUNDISP           (),
        .USER_RXNOTINTABLE        (TILE0_RXNOTINTABLE1_OUT),
        .USER_RXDISPERR           (TILE0_RXDISPERR1_OUT),
        .USER_RXBUFSTATUS         (TILE0_RXBUFSTATUS1_OUT),
        .USER_RXCLKCORCNT         (TILE0_RXCLKCORCNT1_OUT),
        .USER_RXCHANBONDSEQ       (TILE0_RXCHANBONDSEQ1_OUT),
        .USER_RXCHANISALIGNED     (TILE0_RXCHANISALIGNED1_OUT),
        .USER_RXCHANREALIGN       (TILE0_RXCHANREALIGN1_OUT),
        .USER_RXLOSSOFSYNC        (TILE0_RXLOSSOFSYNC1_OUT),
        .USER_RXVALID             (),
        .USER_RXUSRCLK2           (TILE0_RXUSRCLK21_IN),
    
        // Status and reset signals
        .RESET                    (tied_to_ground_i), // I
        .CCI                      (tile1_gtp0_cc_2b_1skp_cco_i), // I [6:0] - Connect to Master output
        .CCO                      ()  // O [6:0] - Connect to Slave input
    );

    assign TILE0_RESETDONE1_OUT = tile0_resetdone1_i;
    assign tile0_rxreset1_i = TILE0_RXRESET1_IN;
    assign tile0_rxbufreset1_i = TILE0_RXBUFRESET1_IN;

    //_________________________________________________________________________
    //_________________________________________________________________________
    //TILE1  (Location)

    ROCKETIO_WRAPPER_TILE #
    (
        // Simulation attributes
        .TILE_SIM_MODE               (WRAPPER_SIM_MODE),
        .TILE_SIM_GTXRESET_SPEEDUP   (WRAPPER_SIM_GTXRESET_SPEEDUP),
        .TILE_SIM_PLL_PERDIV2        (WRAPPER_SIM_PLL_PERDIV2),

        // Channel bonding attributes
        .TILE_CHAN_BOND_MODE_0       ("MASTER"),
        .TILE_CHAN_BOND_LEVEL_0      (2),

        .TILE_CHAN_BOND_MODE_1       ("SLAVE"),
        .TILE_CHAN_BOND_LEVEL_1      (1),
        
        .REVERSE_LANES               (REVERSE_LANES) 
    )
    tile1_rocketio_wrapper_i
    (
        //---------------------- Loopback and Powerdown Ports ----------------------
        .LOOPBACK0_IN                   (TILE1_LOOPBACK0_IN),
        .LOOPBACK1_IN                   (TILE1_LOOPBACK1_IN),
        .RXPOWERDOWN0_IN                (TILE1_RXPOWERDOWN0_IN),
        .RXPOWERDOWN1_IN                (TILE1_RXPOWERDOWN1_IN),
        .TXPOWERDOWN0_IN                (TILE1_TXPOWERDOWN0_IN),
        .TXPOWERDOWN1_IN                (TILE1_TXPOWERDOWN1_IN),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .RXCHARISCOMMA0_OUT             (tile1_rxchariscomma0_i),
        .RXCHARISCOMMA1_OUT             (tile1_rxchariscomma1_i),
        .RXCHARISK0_OUT                 (tile1_rxcharisk0_i),
        .RXCHARISK1_OUT                 (tile1_rxcharisk1_i),
        .RXDISPERR0_OUT                 (tile1_rxdisperr0_i),
        .RXDISPERR1_OUT                 (tile1_rxdisperr1_i),
        .RXNOTINTABLE0_OUT              (tile1_rxnotintable0_i),
        .RXNOTINTABLE1_OUT              (tile1_rxnotintable1_i),
        .RXRUNDISP0_OUT                 (tile1_rxrundisp0_i),
        .RXRUNDISP1_OUT                 (tile1_rxrundisp1_i),
        //----------------- Receive Ports - Channel Bonding Ports ------------------
        .RXCHANBONDSEQ0_OUT             (tile1_rxchanbondseq0_i),
        .RXCHANBONDSEQ1_OUT             (tile1_rxchanbondseq1_i),
        .RXCHBONDI0_IN                  (tied_to_ground_vec_i[3:0]),
        .RXCHBONDI1_IN                  (tile1_rxchbondo0_i),
        .RXCHBONDO0_OUT                 (tile1_rxchbondo0_i),
        .RXCHBONDO1_OUT                 (tile1_rxchbondo1_i),
        .RXENCHANSYNC0_IN               (TILE1_RXENCHANSYNC0_IN),
        .RXENCHANSYNC1_IN               (TILE1_RXENCHANSYNC1_IN),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .RXCLKCORCNT0_OUT               (tile1_rxclkcorcnt0_i),
        .RXCLKCORCNT1_OUT               (tile1_rxclkcorcnt1_i),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .RXBYTEISALIGNED0_OUT           (TILE1_RXBYTEISALIGNED0_OUT),
        .RXBYTEISALIGNED1_OUT           (TILE1_RXBYTEISALIGNED1_OUT),
        .RXBYTEREALIGN0_OUT             (TILE1_RXBYTEREALIGN0_OUT),
        .RXBYTEREALIGN1_OUT             (TILE1_RXBYTEREALIGN1_OUT),
        .RXCOMMADET0_OUT                (TILE1_RXCOMMADET0_OUT),
        .RXCOMMADET1_OUT                (TILE1_RXCOMMADET1_OUT),
        .RXENMCOMMAALIGN0_IN            (TILE1_RXENMCOMMAALIGN0_IN),
        .RXENMCOMMAALIGN1_IN            (TILE1_RXENMCOMMAALIGN1_IN),
        .RXENPCOMMAALIGN0_IN            (TILE1_RXENPCOMMAALIGN0_IN),
        .RXENPCOMMAALIGN1_IN            (TILE1_RXENPCOMMAALIGN1_IN),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .RXDATA0_OUT                    (tile1_rxdata0_i),
        .RXDATA1_OUT                    (tile1_rxdata1_i),
        .RXRECCLK0_OUT                  (tile1_rxrecclk0_i),
        .RXRECCLK1_OUT                  (tile1_rxrecclk1_i),
        .RXRESET0_IN                    (tile1_rxreset0_i),
        .RXRESET1_IN                    (tile1_rxreset1_i),
        .RXUSRCLK0_IN                   (tile1_rxrecclk0_bufg_i),
        .RXUSRCLK1_IN                   (tile1_rxrecclk0_bufg_i),
        .RXUSRCLK20_IN                  (tile1_rxrecclk0_bufg_i),
        .RXUSRCLK21_IN                  (tile1_rxrecclk0_bufg_i),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .RXCDRRESET0_IN                 (TILE1_RXCDRRESET0_IN),
        .RXCDRRESET1_IN                 (TILE1_RXCDRRESET1_IN),
        .RXELECIDLE0_OUT                (TILE1_RXELECIDLE0_OUT),
        .RXELECIDLE1_OUT                (TILE1_RXELECIDLE1_OUT),
        .RXN0_IN                        (TILE1_RXN0_IN),
        .RXN1_IN                        (TILE1_RXN1_IN),
        .RXP0_IN                        (TILE1_RXP0_IN),
        .RXP1_IN                        (TILE1_RXP1_IN),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .RXBUFRESET0_IN                 (tile1_rxbufreset0_i),
        .RXBUFRESET1_IN                 (tile1_rxbufreset1_i),
        .RXBUFSTATUS0_OUT               (tile1_rxbufstatus0_i),
        .RXBUFSTATUS1_OUT               (tile1_rxbufstatus1_i),
        .RXCHANISALIGNED0_OUT           (tile1_rxchanisaligned0_i),
        .RXCHANISALIGNED1_OUT           (tile1_rxchanisaligned1_i),
        .RXCHANREALIGN0_OUT             (tile1_rxchanrealign0_i),
        .RXCHANREALIGN1_OUT             (tile1_rxchanrealign1_i),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .RXLOSSOFSYNC0_OUT              (tile1_rxlossofsync0_i),
        .RXLOSSOFSYNC1_OUT              (tile1_rxlossofsync1_i),
        //------------ Receive Ports - RX Pipe Control for PCI Express -------------
        .RXVALID0_OUT                   (tile1_rxvalid0_i),
        .RXVALID1_OUT                   (tile1_rxvalid1_i),
        //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
        .DADDR_IN                       (TILE1_DADDR_IN),
        .DCLK_IN                        (TILE1_DCLK_IN),
        .DEN_IN                         (TILE1_DEN_IN),
        .DI_IN                          (TILE1_DI_IN),
        .DO_OUT                         (TILE1_DO_OUT),
        .DRDY_OUT                       (TILE1_DRDY_OUT),
        .DWE_IN                         (TILE1_DWE_IN),
        //------------------- Shared Ports - Tile and PLL Ports --------------------
        .CLKIN_IN                       (TILE1_CLKIN_IN),
        .GTXRESET_IN                    (TILE1_GTXRESET_IN),
        .PLLLKDET_OUT                   (TILE1_PLLLKDET_OUT),
        .REFCLKOUT_OUT                  (TILE1_REFCLKOUT_OUT),
        .RESETDONE0_OUT                 (tile1_resetdone0_i),
        .RESETDONE1_OUT                 (tile1_resetdone1_i),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .TXCHARISK0_IN                  (TILE1_TXCHARISK0_IN),
        .TXCHARISK1_IN                  (TILE1_TXCHARISK1_IN),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA0_IN                     (TILE1_TXDATA0_IN),
        .TXDATA1_IN                     (TILE1_TXDATA1_IN),
        .TXRESET0_IN                    (TILE1_TXRESET0_IN),
        .TXRESET1_IN                    (TILE1_TXRESET1_IN),
        .TXUSRCLK0_IN                   (TILE1_TXUSRCLK0_IN),
        .TXUSRCLK1_IN                   (TILE1_TXUSRCLK1_IN),
        .TXUSRCLK20_IN                  (TILE1_TXUSRCLK20_IN),
        .TXUSRCLK21_IN                  (TILE1_TXUSRCLK21_IN),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
                
        .TXN0_OUT                       (TILE1_TXN0_OUT),
        .TXN1_OUT                       (TILE1_TXN1_OUT),
        .TXP0_OUT                       (TILE1_TXP0_OUT),
        .TXP1_OUT                       (TILE1_TXP1_OUT),
         
        //------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .TXENPMAPHASEALIGN0_IN          (TILE1_TXENPMAPHASEALIGN0_IN),
        .TXENPMAPHASEALIGN1_IN          (TILE1_TXENPMAPHASEALIGN1_IN),
        .TXPMASETPHASE0_IN              (TILE1_TXPMASETPHASE0_IN),
        .TXPMASETPHASE1_IN              (TILE1_TXPMASETPHASE1_IN),
        //--------------- Transmit Ports - TX Ports for PCI Express ----------------
        .TXELECIDLE0_IN                 (TILE1_TXELECIDLE0_IN),
        .TXELECIDLE1_IN                 (TILE1_TXELECIDLE1_IN)
    );

    //_________________________________________________________________________
    //_________________________________________________________________________
    /*BUFG tile1_rxrecclk0_bufg0_i
    (
        .I                              (tile1_rxrecclk0_i),
        .O                              (tile1_rxrecclk0_bufg_i)
    );*/
    assign tile1_rxrecclk0_bufg_i = tile1_rxrecclk0_i;

    //_________________________________________________________________________
    //_________________________________________________________________________   
    //TILE1 GTP0
    CC_2B_1SKP #(
        .CC_CHAR                  (8'h1C),     // CC character
        .ALIGN_CHAR               (8'h7C),     // Alignment character
        .CHAN_BOND_MODE           ("MASTER"),     // "MASTER", "OFF", "SLAVE"
        .ALIGN_PARALLEL_CHECK     (1'b1)  // Check alignment in parallel data
    ) tile1_gtp0_cc_2b_1skp_i (
        // Write Interface on the RXRECCLK
        .GT_RXDATA                (tile1_rxdata0_i),
        .GT_RXCHARISK             (tile1_rxcharisk0_i),
        .GT_RXCHARISCOMMA         (tile1_rxchariscomma0_i),
        .GT_RXRUNDISP             (tile1_rxrundisp0_i),
        .GT_RXNOTINTABLE          (tile1_rxnotintable0_i),
        .GT_RXDISPERR             (tile1_rxdisperr0_i),
        .GT_RXBUFSTATUS           (tile1_rxbufstatus0_i),
        .GT_RXCLKCORCNT           (tile1_rxclkcorcnt0_i),
        .GT_RXCHANBONDSEQ         (tile1_rxchanbondseq0_i),
        .GT_RXCHANISALIGNED       (tile1_rxchanisaligned0_i),
        .GT_RXCHANREALIGN         (tile1_rxchanrealign0_i),
        .GT_RXLOSSOFSYNC          (tile1_rxlossofsync0_i),
        .GT_RXVALID               (tile1_rxvalid0_i),
        .GT_RXUSRCLK2             (tile1_rxrecclk0_bufg_i),
    
        // Read Interface on the RXUSRCLK2
        .USER_RXDATA              (TILE1_RXDATA0_OUT),
        .USER_RXCHARISK           (TILE1_RXCHARISK0_OUT),
        .USER_RXCHARISCOMMA       (TILE1_RXCHARISCOMMA0_OUT),
        .USER_RXRUNDISP           (),
        .USER_RXNOTINTABLE        (TILE1_RXNOTINTABLE0_OUT),
        .USER_RXDISPERR           (TILE1_RXDISPERR0_OUT),
        .USER_RXBUFSTATUS         (TILE1_RXBUFSTATUS0_OUT),
        .USER_RXCLKCORCNT         (TILE1_RXCLKCORCNT0_OUT),
        .USER_RXCHANBONDSEQ       (TILE1_RXCHANBONDSEQ0_OUT),
        .USER_RXCHANISALIGNED     (TILE1_RXCHANISALIGNED0_OUT),
        .USER_RXCHANREALIGN       (TILE1_RXCHANREALIGN0_OUT),
        .USER_RXLOSSOFSYNC        (TILE1_RXLOSSOFSYNC0_OUT),
        .USER_RXVALID             (),
        .USER_RXUSRCLK2           (TILE1_RXUSRCLK20_IN),
    
        // Status and reset signals
        .RESET                    (tile1_gtp0_cc_2b_1skp_reset_i), // I
        .CCI                      (tied_to_ground_vec_i[6:0]), // I [6:0] - Connect to Master output
        .CCO                      (tile1_gtp0_cc_2b_1skp_cco_i)  // O [6:0] - Connect to Slave input
    );


    //Reset logic
    assign tile1_gtp0_cc_2b_1skp_reset_i = ~(tile0_resetdone0_i
                                           & tile0_resetdone1_i
                                           & tile1_resetdone0_i
                                           & tile1_resetdone1_i)
                                            | tile1_rxreset0_i | tile1_rxbufreset0_i;

    assign TILE1_RESETDONE0_OUT = tile1_resetdone0_i;
    assign tile1_rxreset0_i = TILE1_RXRESET0_IN;
    assign tile1_rxbufreset0_i = TILE1_RXBUFRESET0_IN;


    //_________________________________________________________________________
    //_________________________________________________________________________   
    //TILE1 GTP1
    CC_2B_1SKP #(
        .CC_CHAR                  (8'h1C),     // CC character
        .ALIGN_CHAR               (8'h7C),     // Alignment character
        .CHAN_BOND_MODE           ("SLAVE"),     // "MASTER", "OFF", "SLAVE"
        .ALIGN_PARALLEL_CHECK     (1'b1)  // Check alignment in parallel data
    ) tile1_gtp1_cc_2b_1skp_i (
        // Write Interface on the RXRECCLK
        .GT_RXDATA                (tile1_rxdata1_i),
        .GT_RXCHARISK             (tile1_rxcharisk1_i),
        .GT_RXCHARISCOMMA         (tile1_rxchariscomma1_i),
        .GT_RXRUNDISP             (tile1_rxrundisp1_i),
        .GT_RXNOTINTABLE          (tile1_rxnotintable1_i),
        .GT_RXDISPERR             (tile1_rxdisperr1_i),
        .GT_RXBUFSTATUS           (tile1_rxbufstatus1_i),
        .GT_RXCLKCORCNT           (tile1_rxclkcorcnt1_i),
        .GT_RXCHANBONDSEQ         (tile1_rxchanbondseq1_i),
        .GT_RXCHANISALIGNED       (tile1_rxchanisaligned1_i),
        .GT_RXCHANREALIGN         (tile1_rxchanrealign1_i),
        .GT_RXLOSSOFSYNC          (tile1_rxlossofsync1_i),
        .GT_RXVALID               (tile1_rxvalid1_i),
        .GT_RXUSRCLK2             (tile1_rxrecclk0_bufg_i),
    
        // Read Interface on the RXUSRCLK2
        .USER_RXDATA              (TILE1_RXDATA1_OUT),
        .USER_RXCHARISK           (TILE1_RXCHARISK1_OUT),
        .USER_RXCHARISCOMMA       (TILE1_RXCHARISCOMMA1_OUT),
        .USER_RXRUNDISP           (),
        .USER_RXNOTINTABLE        (TILE1_RXNOTINTABLE1_OUT),
        .USER_RXDISPERR           (TILE1_RXDISPERR1_OUT),
        .USER_RXBUFSTATUS         (TILE1_RXBUFSTATUS1_OUT),
        .USER_RXCLKCORCNT         (TILE1_RXCLKCORCNT1_OUT),
        .USER_RXCHANBONDSEQ       (TILE1_RXCHANBONDSEQ1_OUT),
        .USER_RXCHANISALIGNED     (TILE1_RXCHANISALIGNED1_OUT),
        .USER_RXCHANREALIGN       (TILE1_RXCHANREALIGN1_OUT),
        .USER_RXLOSSOFSYNC        (TILE1_RXLOSSOFSYNC1_OUT),
        .USER_RXVALID             (),
        .USER_RXUSRCLK2           (TILE1_RXUSRCLK21_IN),
    
        // Status and reset signals
        .RESET                    (tied_to_ground_i), // I
        .CCI                      (tile1_gtp0_cc_2b_1skp_cco_i), // I [6:0] - Connect to Master output
        .CCO                      ()  // O [6:0] - Connect to Slave input
    );

    assign TILE1_RESETDONE1_OUT = tile1_resetdone1_i;
    assign tile1_rxreset1_i = TILE1_RXRESET1_IN;
    assign tile1_rxbufreset1_i = TILE1_RXBUFRESET1_IN;    

endmodule

