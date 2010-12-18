////////////////////////////////////////////////////////////////////////
//
//  NetFPGA-10G http://www.netfpga.org
//
//  Module:
//          rocketio_wrapper_tile.v
//
//  Description:
//          RocketIO wrapper tile with Lane reverse
//                 
//  Revision history:
//          2010/12/8 hyzeng: Initial check-in
//
////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps


//***************************** Entity Declaration ****************************

module ROCKETIO_WRAPPER_TILE #
(
    // Simulation attributes
    parameter   TILE_SIM_MODE              =   "FAST",  // Set to Fast Functional Simulation Model
    parameter   TILE_SIM_GTXRESET_SPEEDUP  =   0,      // Set to 1 to speed up sim reset
    parameter   TILE_SIM_PLL_PERDIV2       =   9'h140,    // Set to the VCO Unit Interval time

    // Channel bonding attributes
    parameter   TILE_CHAN_BOND_MODE_0      =   "OFF",  // "MASTER", "SLAVE", or "OFF"
    parameter   TILE_CHAN_BOND_LEVEL_0     =   0,      // 0 to 7. See UG for details

    parameter   TILE_CHAN_BOND_MODE_1      =   "OFF",  // "MASTER", "SLAVE", or "OFF"
    parameter   TILE_CHAN_BOND_LEVEL_1     =   0,      // 0 to 7. See UG for details
    
    parameter   REVERSE_LANES              =   0
)
(
    //---------------------- Loopback and Powerdown Ports ----------------------
    LOOPBACK0_IN,
    LOOPBACK1_IN,
    RXPOWERDOWN0_IN,
    RXPOWERDOWN1_IN,
    TXPOWERDOWN0_IN,
    TXPOWERDOWN1_IN,
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    RXCHARISCOMMA0_OUT,
    RXCHARISCOMMA1_OUT,
    RXCHARISK0_OUT,
    RXCHARISK1_OUT,
    RXDISPERR0_OUT,
    RXDISPERR1_OUT,
    RXNOTINTABLE0_OUT,
    RXNOTINTABLE1_OUT,
    RXRUNDISP0_OUT,
    RXRUNDISP1_OUT,
    //----------------- Receive Ports - Channel Bonding Ports ------------------
    RXCHANBONDSEQ0_OUT,
    RXCHANBONDSEQ1_OUT,
    RXCHBONDI0_IN,
    RXCHBONDI1_IN,
    RXCHBONDO0_OUT,
    RXCHBONDO1_OUT,
    RXENCHANSYNC0_IN,
    RXENCHANSYNC1_IN,
    //----------------- Receive Ports - Clock Correction Ports -----------------
    RXCLKCORCNT0_OUT,
    RXCLKCORCNT1_OUT,
    //------------- Receive Ports - Comma Detection and Alignment --------------
    RXBYTEISALIGNED0_OUT,
    RXBYTEISALIGNED1_OUT,
    RXBYTEREALIGN0_OUT,
    RXBYTEREALIGN1_OUT,
    RXCOMMADET0_OUT,
    RXCOMMADET1_OUT,
    RXENMCOMMAALIGN0_IN,
    RXENMCOMMAALIGN1_IN,
    RXENPCOMMAALIGN0_IN,
    RXENPCOMMAALIGN1_IN,
    //----------------- Receive Ports - RX Data Path interface -----------------
    RXDATA0_OUT,
    RXDATA1_OUT,
    RXRECCLK0_OUT,
    RXRECCLK1_OUT,
    RXRESET0_IN,
    RXRESET1_IN,
    RXUSRCLK0_IN,
    RXUSRCLK1_IN,
    RXUSRCLK20_IN,
    RXUSRCLK21_IN,
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    RXCDRRESET0_IN,
    RXCDRRESET1_IN,
    RXELECIDLE0_OUT,
    RXELECIDLE1_OUT,
    RXN0_IN,
    RXN1_IN,
    RXP0_IN,
    RXP1_IN,
    //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    RXBUFRESET0_IN,
    RXBUFRESET1_IN,
    RXBUFSTATUS0_OUT,
    RXBUFSTATUS1_OUT,
    RXCHANISALIGNED0_OUT,
    RXCHANISALIGNED1_OUT,
    RXCHANREALIGN0_OUT,
    RXCHANREALIGN1_OUT,
    //------------- Receive Ports - RX Loss-of-sync State Machine --------------
    RXLOSSOFSYNC0_OUT,
    RXLOSSOFSYNC1_OUT,
    //------------ Receive Ports - RX Pipe Control for PCI Express -------------
    RXVALID0_OUT,
    RXVALID1_OUT,
    //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    DADDR_IN,
    DCLK_IN,
    DEN_IN,
    DI_IN,
    DO_OUT,
    DRDY_OUT,
    DWE_IN,
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    CLKIN_IN,
    GTXRESET_IN,
    PLLLKDET_OUT,
    REFCLKOUT_OUT,
    RESETDONE0_OUT,
    RESETDONE1_OUT,
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    TXCHARISK0_IN,
    TXCHARISK1_IN,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    TXDATA0_IN,
    TXDATA1_IN,
    TXRESET0_IN,
    TXRESET1_IN,
    TXUSRCLK0_IN,
    TXUSRCLK1_IN,
    TXUSRCLK20_IN,
    TXUSRCLK21_IN,
    //------------- Transmit Ports - TX Driver and OOB signalling --------------
    TXN0_OUT,
    TXN1_OUT,
    TXP0_OUT,
    TXP1_OUT,
    //------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    TXENPMAPHASEALIGN0_IN,
    TXENPMAPHASEALIGN1_IN,
    TXPMASETPHASE0_IN,
    TXPMASETPHASE1_IN,
    //--------------- Transmit Ports - TX Ports for PCI Express ----------------
    TXELECIDLE0_IN,
    TXELECIDLE1_IN


);

// synthesis attribute X_CORE_INFO of ROCKETIO_WRAPPER_TILE is "gtxwizard_v1_6, Coregen v11.2";

//***************************** Port Declarations *****************************


    //---------------------- Loopback and Powerdown Ports ----------------------
    input   [2:0]   LOOPBACK0_IN;
    input   [2:0]   LOOPBACK1_IN;
    input   [1:0]   RXPOWERDOWN0_IN;
    input   [1:0]   RXPOWERDOWN1_IN;
    input   [1:0]   TXPOWERDOWN0_IN;
    input   [1:0]   TXPOWERDOWN1_IN;
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    output  [1:0]   RXCHARISCOMMA0_OUT;
    output  [1:0]   RXCHARISCOMMA1_OUT;
    output  [1:0]   RXCHARISK0_OUT;
    output  [1:0]   RXCHARISK1_OUT;
    output  [1:0]   RXDISPERR0_OUT;
    output  [1:0]   RXDISPERR1_OUT;
    output  [1:0]   RXNOTINTABLE0_OUT;
    output  [1:0]   RXNOTINTABLE1_OUT;
    output  [1:0]   RXRUNDISP0_OUT;
    output  [1:0]   RXRUNDISP1_OUT;
    //----------------- Receive Ports - Channel Bonding Ports ------------------
    output          RXCHANBONDSEQ0_OUT;
    output          RXCHANBONDSEQ1_OUT;
    input   [3:0]   RXCHBONDI0_IN;
    input   [3:0]   RXCHBONDI1_IN;
    output  [3:0]   RXCHBONDO0_OUT;
    output  [3:0]   RXCHBONDO1_OUT;
    input           RXENCHANSYNC0_IN;
    input           RXENCHANSYNC1_IN;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    output  [2:0]   RXCLKCORCNT0_OUT;
    output  [2:0]   RXCLKCORCNT1_OUT;
    //------------- Receive Ports - Comma Detection and Alignment --------------
    output          RXBYTEISALIGNED0_OUT;
    output          RXBYTEISALIGNED1_OUT;
    output          RXBYTEREALIGN0_OUT;
    output          RXBYTEREALIGN1_OUT;
    output          RXCOMMADET0_OUT;
    output          RXCOMMADET1_OUT;
    input           RXENMCOMMAALIGN0_IN;
    input           RXENMCOMMAALIGN1_IN;
    input           RXENPCOMMAALIGN0_IN;
    input           RXENPCOMMAALIGN1_IN;
    //----------------- Receive Ports - RX Data Path interface -----------------
    output  [15:0]  RXDATA0_OUT;
    output  [15:0]  RXDATA1_OUT;
    output          RXRECCLK0_OUT;
    output          RXRECCLK1_OUT;
    input           RXRESET0_IN;
    input           RXRESET1_IN;
    input           RXUSRCLK0_IN;
    input           RXUSRCLK1_IN;
    input           RXUSRCLK20_IN;
    input           RXUSRCLK21_IN;
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    input           RXCDRRESET0_IN;
    input           RXCDRRESET1_IN;
    output          RXELECIDLE0_OUT;
    output          RXELECIDLE1_OUT;
    input           RXN0_IN;
    input           RXN1_IN;
    input           RXP0_IN;
    input           RXP1_IN;
    //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    input           RXBUFRESET0_IN;
    input           RXBUFRESET1_IN;
    output  [2:0]   RXBUFSTATUS0_OUT;
    output  [2:0]   RXBUFSTATUS1_OUT;
    output          RXCHANISALIGNED0_OUT;
    output          RXCHANISALIGNED1_OUT;
    output          RXCHANREALIGN0_OUT;
    output          RXCHANREALIGN1_OUT;
    //------------- Receive Ports - RX Loss-of-sync State Machine --------------
    output  [1:0]   RXLOSSOFSYNC0_OUT;
    output  [1:0]   RXLOSSOFSYNC1_OUT;
    //------------ Receive Ports - RX Pipe Control for PCI Express -------------
    output          RXVALID0_OUT;
    output          RXVALID1_OUT;
    //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    input   [6:0]   DADDR_IN;
    input           DCLK_IN;
    input           DEN_IN;
    input   [15:0]  DI_IN;
    output  [15:0]  DO_OUT;
    output          DRDY_OUT;
    input           DWE_IN;
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    input           CLKIN_IN;
    input           GTXRESET_IN;
    output          PLLLKDET_OUT;
    output          REFCLKOUT_OUT;
    output          RESETDONE0_OUT;
    output          RESETDONE1_OUT;
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    input   [1:0]   TXCHARISK0_IN;
    input   [1:0]   TXCHARISK1_IN;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input   [15:0]  TXDATA0_IN;
    input   [15:0]  TXDATA1_IN;
    input           TXRESET0_IN;
    input           TXRESET1_IN;
    input           TXUSRCLK0_IN;
    input           TXUSRCLK1_IN;
    input           TXUSRCLK20_IN;
    input           TXUSRCLK21_IN;
    //------------- Transmit Ports - TX Driver and OOB signalling --------------
    output          TXN0_OUT;
    output          TXN1_OUT;
    output          TXP0_OUT;
    output          TXP1_OUT;
    //------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    input           TXENPMAPHASEALIGN0_IN;
    input           TXENPMAPHASEALIGN1_IN;
    input           TXPMASETPHASE0_IN;
    input           TXPMASETPHASE1_IN;
    //--------------- Transmit Ports - TX Ports for PCI Express ----------------
    input           TXELECIDLE0_IN;
    input           TXELECIDLE1_IN;



//***************************** Wire Declarations *****************************

    // ground and vcc signals
    wire            tied_to_ground_i;
    wire    [63:0]  tied_to_ground_vec_i;
    wire            tied_to_vcc_i;
    wire    [63:0]  tied_to_vcc_vec_i;




    //RX Datapath signals
    wire    [31:0]  rxdata0_i;
    wire    [1:0]   rxchariscomma0_float_i;
    wire    [1:0]   rxcharisk0_float_i;
    wire    [1:0]   rxdisperr0_float_i;
    wire    [1:0]   rxnotintable0_float_i;
    wire    [1:0]   rxrundisp0_float_i;

    //TX Datapath signals
    wire    [31:0]  txdata0_i;
    wire    [1:0]   txkerr0_float_i;
    wire    [1:0]   txrundisp0_float_i;

    //RX Datapath signals
    wire    [31:0]  rxdata1_i;
    wire    [1:0]   rxchariscomma1_float_i;
    wire    [1:0]   rxcharisk1_float_i;
    wire    [1:0]   rxdisperr1_float_i;
    wire    [1:0]   rxnotintable1_float_i;
    wire    [1:0]   rxrundisp1_float_i;

    //TX Datapath signals
    wire    [31:0]  txdata1_i;
    wire    [1:0]   txkerr1_float_i;
    wire    [1:0]   txrundisp1_float_i;

//
//********************************* Main Body of Code**************************

    //-------------------------  Static signal Assigments ---------------------

    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 64'hffffffffffffffff;


    //-------------------  GTX Datapath byte mapping  -----------------


    assign  RXDATA0_OUT    =   rxdata0_i[15:0];

    // The GTX transmits little endian data (TXDATA[7:0] transmitted first)
    assign  txdata0_i    =   {tied_to_ground_vec_i[15:0],TXDATA0_IN};

    assign  RXDATA1_OUT    =   rxdata1_i[15:0];

    // The GTX transmits little endian data (TXDATA[7:0] transmitted first)
    assign  txdata1_i    =   {tied_to_ground_vec_i[15:0],TXDATA1_IN};




    generate
    if(REVERSE_LANES == 0) begin: NO_REVERSE_LANES


    //------------------------- GTX Instantiations  --------------------------

    GTX_DUAL #
    (
        //_______________________ Simulation-Only Attributes __________________

        .SIM_RECEIVER_DETECT_PASS_0  ("TRUE"),
        .SIM_RECEIVER_DETECT_PASS_1  ("TRUE"),
        .SIM_MODE                    (TILE_SIM_MODE),
        .SIM_GTXRESET_SPEEDUP        (TILE_SIM_GTXRESET_SPEEDUP),
        .SIM_PLL_PERDIV2             (TILE_SIM_PLL_PERDIV2),

        //___________________________ Shared Attributes _______________________

        //---------------------- Tile and PLL Attributes ----------------------

        .CLK25_DIVIDER               (10),
        .CLKINDC_B                   ("TRUE"),
        .CLKRCV_TRST                 ("TRUE"),
        .OOB_CLK_DIVIDER             (6),
        .OVERSAMPLE_MODE             ("FALSE"),
        .PLL_COM_CFG                 (24'h21680a),
        .PLL_CP_CFG                  (8'h00),
        .PLL_DIVSEL_FB               (2),
        .PLL_DIVSEL_REF              (1),
        .PLL_FB_DCCEN                ("FALSE"),
        .PLL_LKDET_CFG               (3'b101),
        .PLL_TDCC_CFG                (3'b000),
        .PMA_COM_CFG                 (69'h000000000000000000),

        //______________________ Transmit Interface Attributes ________________


        //----------------- TX Buffering and Phase Alignment ------------------

        .TX_BUFFER_USE_0            ("TRUE"),
        .TX_XCLK_SEL_0              ("TXOUT"),
        .TXRX_INVERT_0              (3'b011),

        .TX_BUFFER_USE_1            ("TRUE"),
        .TX_XCLK_SEL_1              ("TXOUT"),
        .TXRX_INVERT_1              (3'b011),

        //------------------- TX Gearbox Settings -----------------------------

        .GEARBOX_ENDEC_0            (3'b000),
        .TXGEARBOX_USE_0            ("FALSE"),

        .GEARBOX_ENDEC_1            (3'b000),
        .TXGEARBOX_USE_1            ("FALSE"),

        //------------------- TX Serial Line Rate settings --------------------

        .PLL_TXDIVSEL_OUT_0         (1),

        .PLL_TXDIVSEL_OUT_1         (1),

        //------------------- TX Driver and OOB signalling --------------------

        .CM_TRIM_0                 (2'b10),
        .PMA_TX_CFG_0              (20'h80082),
        .TX_DETECT_RX_CFG_0        (14'h1832),
        .TX_IDLE_DELAY_0           (3'b010),

        .CM_TRIM_1                 (2'b10),
        .PMA_TX_CFG_1              (20'h80082),
        .TX_DETECT_RX_CFG_1        (14'h1832),
        .TX_IDLE_DELAY_1           (3'b010),

        //---------------- TX Pipe Control for PCI Express/SATA ---------------

        .COM_BURST_VAL_0            (4'b1111),

        .COM_BURST_VAL_1            (4'b1111),

        //_______________________ Receive Interface Attributes ________________


        //---------- RX Driver,OOB signalling,Coupling and Eq.,CDR ------------

        .AC_CAP_DIS_0               ("TRUE"),
        .OOBDETECT_THRESHOLD_0      (3'b111),
        .PMA_CDR_SCAN_0             (27'h640403a),
        .PMA_RX_CFG_0               (25'h0f44088),
        .RCV_TERM_GND_0             ("FALSE"),
        .RCV_TERM_VTTRX_0           ("FALSE"),
        .TERMINATION_IMP_0          (50),

        .AC_CAP_DIS_1               ("TRUE"),
        .OOBDETECT_THRESHOLD_1      (3'b111),
        .PMA_CDR_SCAN_1             (27'h640403a),
        .PMA_RX_CFG_1               (25'h0f44088),
        .RCV_TERM_GND_1             ("FALSE"),
        .RCV_TERM_VTTRX_1           ("FALSE"),
        .TERMINATION_IMP_1          (50),

        .TERMINATION_CTRL           (5'b10100),
        .TERMINATION_OVRD           ("FALSE"),

        //-------------- RX Decision Feedback Equalizer(DFE)  ----------------

        .DFE_CFG_0                  (10'b1001111011),

        .DFE_CFG_1                  (10'b1001111011),

        .DFE_CAL_TIME               (5'b00110),

        //------------------- RX Serial Line Rate Settings --------------------

        .PLL_RXDIVSEL_OUT_0         (1),
        .PLL_SATA_0                 ("FALSE"),

        .PLL_RXDIVSEL_OUT_1         (1),
        .PLL_SATA_1                 ("FALSE"),


        //------------------------- PRBS Detection ----------------------------

        .PRBS_ERR_THRESHOLD_0       (32'h00000001),

        .PRBS_ERR_THRESHOLD_1       (32'h00000001),

        //------------------- Comma Detection and Alignment -------------------

        .ALIGN_COMMA_WORD_0         (1),
        .COMMA_10B_ENABLE_0         (10'b0001111111),
        .COMMA_DOUBLE_0             ("FALSE"),
        .DEC_MCOMMA_DETECT_0        ("TRUE"),
        .DEC_PCOMMA_DETECT_0        ("TRUE"),
        .DEC_VALID_COMMA_ONLY_0     ("TRUE"),
        .MCOMMA_10B_VALUE_0         (10'b1010000011),
        .MCOMMA_DETECT_0            ("TRUE"),
        .PCOMMA_10B_VALUE_0         (10'b0101111100),
        .PCOMMA_DETECT_0            ("TRUE"),
        .RX_SLIDE_MODE_0            ("PCS"),

        .ALIGN_COMMA_WORD_1         (1),
        .COMMA_10B_ENABLE_1         (10'b0001111111),
        .COMMA_DOUBLE_1             ("FALSE"),
        .DEC_MCOMMA_DETECT_1        ("TRUE"),
        .DEC_PCOMMA_DETECT_1        ("TRUE"),
        .DEC_VALID_COMMA_ONLY_1     ("TRUE"),
        .MCOMMA_10B_VALUE_1         (10'b1010000011),
        .MCOMMA_DETECT_1            ("TRUE"),
        .PCOMMA_10B_VALUE_1         (10'b0101111100),
        .PCOMMA_DETECT_1            ("TRUE"),
        .RX_SLIDE_MODE_1            ("PCS"),


        //------------------- RX Loss-of-sync State Machine -------------------
        .RX_LOSS_OF_SYNC_FSM_0      ("TRUE"),
        .RX_LOS_INVALID_INCR_0      (1),
        .RX_LOS_THRESHOLD_0         (4),

        .RX_LOSS_OF_SYNC_FSM_1      ("TRUE"),
        .RX_LOS_INVALID_INCR_1      (1),
        .RX_LOS_THRESHOLD_1         (4),

        //------------------- RX Gearbox Settings -----------------------------

        .RXGEARBOX_USE_0            ("FALSE"),

        .RXGEARBOX_USE_1            ("FALSE"),

        //------------ RX Elastic Buffer and Phase alignment ports ------------

        .PMA_RXSYNC_CFG_0           (7'h00),
        .RX_BUFFER_USE_0            ("TRUE"),
        .RX_XCLK_SEL_0              ("RXREC"),

        .PMA_RXSYNC_CFG_1           (7'h00),
        .RX_BUFFER_USE_1            ("TRUE"),
        .RX_XCLK_SEL_1              ("RXREC"),

        //--------------------- Clock Correction Attributes -------------------

        .CLK_CORRECT_USE_0          ("FALSE"),
        .CLK_COR_ADJ_LEN_0          (1),
        .CLK_COR_DET_LEN_0          (1),
        .CLK_COR_INSERT_IDLE_FLAG_0 ("FALSE"),
        .CLK_COR_KEEP_IDLE_0        ("FALSE"),
        .CLK_COR_MAX_LAT_0          (20),
        .CLK_COR_MIN_LAT_0          (18),
        .CLK_COR_PRECEDENCE_0       ("TRUE"),
        .CLK_COR_REPEAT_WAIT_0      (0),
        .CLK_COR_SEQ_1_1_0          (10'b0100000000),
        .CLK_COR_SEQ_1_2_0          (10'b0000000000),
        .CLK_COR_SEQ_1_3_0          (10'b0000000000),
        .CLK_COR_SEQ_1_4_0          (10'b0000000000),
        .CLK_COR_SEQ_1_ENABLE_0     (4'b1111),
        .CLK_COR_SEQ_2_1_0          (10'b0100000000),
        .CLK_COR_SEQ_2_2_0          (10'b0000000000),
        .CLK_COR_SEQ_2_3_0          (10'b0000000000),
        .CLK_COR_SEQ_2_4_0          (10'b0000000000),
        .CLK_COR_SEQ_2_ENABLE_0     (4'b1111),
        .CLK_COR_SEQ_2_USE_0        ("FALSE"),
        .RX_DECODE_SEQ_MATCH_0      ("TRUE"),

        .CLK_CORRECT_USE_1          ("FALSE"),
        .CLK_COR_ADJ_LEN_1          (1),
        .CLK_COR_DET_LEN_1          (1),
        .CLK_COR_INSERT_IDLE_FLAG_1 ("FALSE"),
        .CLK_COR_KEEP_IDLE_1        ("FALSE"),
        .CLK_COR_MAX_LAT_1          (20),
        .CLK_COR_MIN_LAT_1          (18),
        .CLK_COR_PRECEDENCE_1       ("TRUE"),
        .CLK_COR_REPEAT_WAIT_1      (0),
        .CLK_COR_SEQ_1_1_1          (10'b0100000000),
        .CLK_COR_SEQ_1_2_1          (10'b0000000000),
        .CLK_COR_SEQ_1_3_1          (10'b0000000000),
        .CLK_COR_SEQ_1_4_1          (10'b0000000000),
        .CLK_COR_SEQ_1_ENABLE_1     (4'b1111),
        .CLK_COR_SEQ_2_1_1          (10'b0100000000),
        .CLK_COR_SEQ_2_2_1          (10'b0000000000),
        .CLK_COR_SEQ_2_3_1          (10'b0000000000),
        .CLK_COR_SEQ_2_4_1          (10'b0000000000),
        .CLK_COR_SEQ_2_ENABLE_1     (4'b1111),
        .CLK_COR_SEQ_2_USE_1        ("FALSE"),
        .RX_DECODE_SEQ_MATCH_1      ("TRUE"),

        //-------------------- Channel Bonding Attributes ---------------------

        .CB2_INH_CC_PERIOD_0        (8),
        .CHAN_BOND_1_MAX_SKEW_0     (7),
        .CHAN_BOND_2_MAX_SKEW_0     (1),
        .CHAN_BOND_KEEP_ALIGN_0     ("FALSE"),
        .CHAN_BOND_LEVEL_0          (TILE_CHAN_BOND_LEVEL_0),
        .CHAN_BOND_MODE_0           (TILE_CHAN_BOND_MODE_0),
        .CHAN_BOND_SEQ_1_1_0        (10'b0101111100),
        .CHAN_BOND_SEQ_1_2_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_3_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_4_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_ENABLE_0   (4'b0001),
        .CHAN_BOND_SEQ_2_1_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_2_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_3_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_4_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_ENABLE_0   (4'b0000),
        .CHAN_BOND_SEQ_2_USE_0      ("FALSE"),
        .CHAN_BOND_SEQ_LEN_0        (1),
        .PCI_EXPRESS_MODE_0         ("FALSE"),

        .CB2_INH_CC_PERIOD_1        (8),
        .CHAN_BOND_1_MAX_SKEW_1     (7),
        .CHAN_BOND_2_MAX_SKEW_1     (1),
        .CHAN_BOND_KEEP_ALIGN_1     ("FALSE"),
        .CHAN_BOND_LEVEL_1          (TILE_CHAN_BOND_LEVEL_1),
        .CHAN_BOND_MODE_1           (TILE_CHAN_BOND_MODE_1),
        .CHAN_BOND_SEQ_1_1_1        (10'b0101111100),
        .CHAN_BOND_SEQ_1_2_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_3_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_4_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_ENABLE_1   (4'b0001),
        .CHAN_BOND_SEQ_2_1_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_2_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_3_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_4_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_ENABLE_1   (4'b0000),
        .CHAN_BOND_SEQ_2_USE_1      ("FALSE"),
        .CHAN_BOND_SEQ_LEN_1        (1),
        .PCI_EXPRESS_MODE_1         ("FALSE"),

        //------ RX Attributes to Control Reset after Electrical Idle  ------

        .RX_EN_IDLE_HOLD_DFE_0      ("TRUE"),
        .RX_EN_IDLE_RESET_BUF_0     ("TRUE"),
        .RX_IDLE_HI_CNT_0           (4'b1000),
        .RX_IDLE_LO_CNT_0           (4'b0000),

        .RX_EN_IDLE_HOLD_DFE_1      ("TRUE"),
        .RX_EN_IDLE_RESET_BUF_1     ("TRUE"),
        .RX_IDLE_HI_CNT_1           (4'b1000),
        .RX_IDLE_LO_CNT_1           (4'b0000),


        .CDR_PH_ADJ_TIME            (5'b01010),
        .RX_EN_IDLE_RESET_FR        ("TRUE"),
        .RX_EN_IDLE_HOLD_CDR        ("FALSE"),
        .RX_EN_IDLE_RESET_PH        ("TRUE"),

        //---------------- RX Attributes for PCI Express/SATA ---------------

        .RX_STATUS_FMT_0            ("PCIE"),
        .SATA_BURST_VAL_0           (3'b100),
        .SATA_IDLE_VAL_0            (3'b100),
        .SATA_MAX_BURST_0           (7),
        .SATA_MAX_INIT_0            (22),
        .SATA_MAX_WAKE_0            (7),
        .SATA_MIN_BURST_0           (4),
        .SATA_MIN_INIT_0            (12),
        .SATA_MIN_WAKE_0            (4),
        .TRANS_TIME_FROM_P2_0       (16'h003c),
        .TRANS_TIME_NON_P2_0        (16'h0019),
        .TRANS_TIME_TO_P2_0         (16'h0064),

        .RX_STATUS_FMT_1            ("PCIE"),
        .SATA_BURST_VAL_1           (3'b100),
        .SATA_IDLE_VAL_1            (3'b100),
        .SATA_MAX_BURST_1           (7),
        .SATA_MAX_INIT_1            (22),
        .SATA_MAX_WAKE_1            (7),
        .SATA_MIN_BURST_1           (4),
        .SATA_MIN_INIT_1            (12),
        .SATA_MIN_WAKE_1            (4),
        .TRANS_TIME_FROM_P2_1       (16'h003c),
        .TRANS_TIME_NON_P2_1        (16'h0019),
        .TRANS_TIME_TO_P2_1         (16'h0064)
     )
     gtx_dual_i
     (

        //---------------------- Loopback and Powerdown Ports ----------------------
        .LOOPBACK0                      (LOOPBACK0_IN),
        .LOOPBACK1                      (LOOPBACK1_IN),
        .RXPOWERDOWN0                   (RXPOWERDOWN0_IN),
        .RXPOWERDOWN1                   (RXPOWERDOWN1_IN),
        .TXPOWERDOWN0                   (TXPOWERDOWN0_IN),
        .TXPOWERDOWN1                   (TXPOWERDOWN1_IN),
        //------------ Receive Ports - 64b66b and 64b67b Gearbox Ports -------------
        .RXDATAVALID0                   (),
        .RXDATAVALID1                   (),
        .RXGEARBOXSLIP0                 (tied_to_ground_i),
        .RXGEARBOXSLIP1                 (tied_to_ground_i),
        .RXHEADER0                      (),
        .RXHEADER1                      (),
        .RXHEADERVALID0                 (),
        .RXHEADERVALID1                 (),
        .RXSTARTOFSEQ0                  (),
        .RXSTARTOFSEQ1                  (),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .RXCHARISCOMMA0                 ({rxchariscomma0_float_i,RXCHARISCOMMA0_OUT}),
        .RXCHARISCOMMA1                 ({rxchariscomma1_float_i,RXCHARISCOMMA1_OUT}),
        .RXCHARISK0                     ({rxcharisk0_float_i,RXCHARISK0_OUT}),
        .RXCHARISK1                     ({rxcharisk1_float_i,RXCHARISK1_OUT}),
        .RXDEC8B10BUSE0                 (tied_to_vcc_i),
        .RXDEC8B10BUSE1                 (tied_to_vcc_i),
        .RXDISPERR0                     ({rxdisperr0_float_i,RXDISPERR0_OUT}),
        .RXDISPERR1                     ({rxdisperr1_float_i,RXDISPERR1_OUT}),
        .RXNOTINTABLE0                  ({rxnotintable0_float_i,RXNOTINTABLE0_OUT}),
        .RXNOTINTABLE1                  ({rxnotintable1_float_i,RXNOTINTABLE1_OUT}),
        .RXRUNDISP0                     ({rxrundisp0_float_i,RXRUNDISP0_OUT}),
        .RXRUNDISP1                     ({rxrundisp1_float_i,RXRUNDISP1_OUT}),
        //----------------- Receive Ports - Channel Bonding Ports ------------------
        .RXCHANBONDSEQ0                 (RXCHANBONDSEQ0_OUT),
        .RXCHANBONDSEQ1                 (RXCHANBONDSEQ1_OUT),
        .RXCHBONDI0                     (RXCHBONDI0_IN),
        .RXCHBONDI1                     (RXCHBONDI1_IN),
        .RXCHBONDO0                     (RXCHBONDO0_OUT),
        .RXCHBONDO1                     (RXCHBONDO1_OUT),
        .RXENCHANSYNC0                  (RXENCHANSYNC0_IN),
        .RXENCHANSYNC1                  (RXENCHANSYNC1_IN),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .RXCLKCORCNT0                   (RXCLKCORCNT0_OUT),
        .RXCLKCORCNT1                   (RXCLKCORCNT1_OUT),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .RXBYTEISALIGNED0               (RXBYTEISALIGNED0_OUT),
        .RXBYTEISALIGNED1               (RXBYTEISALIGNED1_OUT),
        .RXBYTEREALIGN0                 (RXBYTEREALIGN0_OUT),
        .RXBYTEREALIGN1                 (RXBYTEREALIGN1_OUT),
        .RXCOMMADET0                    (RXCOMMADET0_OUT),
        .RXCOMMADET1                    (RXCOMMADET1_OUT),
        .RXCOMMADETUSE0                 (tied_to_vcc_i),
        .RXCOMMADETUSE1                 (tied_to_vcc_i),
        .RXENMCOMMAALIGN0               (RXENMCOMMAALIGN0_IN),
        .RXENMCOMMAALIGN1               (RXENMCOMMAALIGN1_IN),
        .RXENPCOMMAALIGN0               (RXENPCOMMAALIGN0_IN),
        .RXENPCOMMAALIGN1               (RXENPCOMMAALIGN1_IN),
        .RXSLIDE0                       (tied_to_ground_i),
        .RXSLIDE1                       (tied_to_ground_i),
        //--------------------- Receive Ports - PRBS Detection ---------------------
        .PRBSCNTRESET0                  (tied_to_ground_i),
        .PRBSCNTRESET1                  (tied_to_ground_i),
        .RXENPRBSTST0                   (tied_to_ground_vec_i[1:0]),
        .RXENPRBSTST1                   (tied_to_ground_vec_i[1:0]),
        .RXPRBSERR0                     (),
        .RXPRBSERR1                     (),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .RXDATA0                        (rxdata0_i),
        .RXDATA1                        (rxdata1_i),
        .RXDATAWIDTH0                   (2'b01),
        .RXDATAWIDTH1                   (2'b01),
        .RXRECCLK0                      (RXRECCLK0_OUT),
        .RXRECCLK1                      (RXRECCLK1_OUT),
        .RXRESET0                       (RXRESET0_IN),
        .RXRESET1                       (RXRESET1_IN),
        .RXUSRCLK0                      (RXUSRCLK0_IN),
        .RXUSRCLK1                      (RXUSRCLK1_IN),
        .RXUSRCLK20                     (RXUSRCLK20_IN),
        .RXUSRCLK21                     (RXUSRCLK21_IN),
        //---------- Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
        .DFECLKDLYADJ0                  (tied_to_ground_vec_i[5:0]),
        .DFECLKDLYADJ1                  (tied_to_ground_vec_i[5:0]),
        .DFECLKDLYADJMONITOR0           (),
        .DFECLKDLYADJMONITOR1           (),
        .DFEEYEDACMONITOR0              (),
        .DFEEYEDACMONITOR1              (),
        .DFESENSCAL0                    (),
        .DFESENSCAL1                    (),
        .DFETAP10                       (tied_to_ground_vec_i[4:0]),
        .DFETAP11                       (tied_to_ground_vec_i[4:0]),
        .DFETAP1MONITOR0                (),
        .DFETAP1MONITOR1                (),
        .DFETAP20                       (tied_to_ground_vec_i[4:0]),
        .DFETAP21                       (tied_to_ground_vec_i[4:0]),
        .DFETAP2MONITOR0                (),
        .DFETAP2MONITOR1                (),
        .DFETAP30                       (tied_to_ground_vec_i[3:0]),
        .DFETAP31                       (tied_to_ground_vec_i[3:0]),
        .DFETAP3MONITOR0                (),
        .DFETAP3MONITOR1                (),
        .DFETAP40                       (tied_to_ground_vec_i[3:0]),
        .DFETAP41                       (tied_to_ground_vec_i[3:0]),
        .DFETAP4MONITOR0                (),
        .DFETAP4MONITOR1                (),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .RXCDRRESET0                    (RXCDRRESET0_IN),
        .RXCDRRESET1                    (RXCDRRESET1_IN),
        .RXELECIDLE0                    (RXELECIDLE0_OUT),
        .RXELECIDLE1                    (RXELECIDLE1_OUT),
        .RXENEQB0                       (tied_to_ground_i),
        .RXENEQB1                       (tied_to_ground_i),
        .RXEQMIX0                       (2'b11),
        .RXEQMIX1                       (2'b11),
        .RXEQPOLE0                      (4'b0000),
        .RXEQPOLE1                      (4'b0000),
        .RXN0                           (RXN0_IN),
        .RXN1                           (RXN1_IN),
        .RXP0                           (RXP0_IN),
        .RXP1                           (RXP1_IN),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .RXBUFRESET0                    (RXBUFRESET0_IN),
        .RXBUFRESET1                    (RXBUFRESET1_IN),
        .RXBUFSTATUS0                   (RXBUFSTATUS0_OUT),
        .RXBUFSTATUS1                   (RXBUFSTATUS1_OUT),
        .RXCHANISALIGNED0               (RXCHANISALIGNED0_OUT),
        .RXCHANISALIGNED1               (RXCHANISALIGNED1_OUT),
        .RXCHANREALIGN0                 (RXCHANREALIGN0_OUT),
        .RXCHANREALIGN1                 (RXCHANREALIGN1_OUT),
        .RXENPMAPHASEALIGN0             (tied_to_ground_i),
        .RXENPMAPHASEALIGN1             (tied_to_ground_i),
        .RXPMASETPHASE0                 (tied_to_ground_i),
        .RXPMASETPHASE1                 (tied_to_ground_i),
        .RXSTATUS0                      (),
        .RXSTATUS1                      (),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .RXLOSSOFSYNC0                  (RXLOSSOFSYNC0_OUT),
        .RXLOSSOFSYNC1                  (RXLOSSOFSYNC1_OUT),
        //-------------------- Receive Ports - RX Oversampling ---------------------
        .RXENSAMPLEALIGN0               (tied_to_ground_i),
        .RXENSAMPLEALIGN1               (tied_to_ground_i),
        .RXOVERSAMPLEERR0               (),
        .RXOVERSAMPLEERR1               (),
        //------------ Receive Ports - RX Pipe Control for PCI Express -------------
        .PHYSTATUS0                     (),
        .PHYSTATUS1                     (),
        .RXVALID0                       (RXVALID0_OUT),
        .RXVALID1                       (RXVALID1_OUT),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .RXPOLARITY0                    (tied_to_ground_i),
        .RXPOLARITY1                    (tied_to_ground_i),
        //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
        .DADDR                          (DADDR_IN),
        .DCLK                           (DCLK_IN),
        .DEN                            (DEN_IN),
        .DI                             (DI_IN),
        .DO                             (DO_OUT),
        .DRDY                           (DRDY_OUT),
        .DWE                            (DWE_IN),
        //------------------- Shared Ports - Tile and PLL Ports --------------------
        .CLKIN                          (CLKIN_IN),
        .GTXRESET                       (GTXRESET_IN),
        .GTXTEST                        (14'b10000000000000),
        .INTDATAWIDTH                   (tied_to_vcc_i),
        .PLLLKDET                       (PLLLKDET_OUT),
        .PLLLKDETEN                     (tied_to_vcc_i),
        .PLLPOWERDOWN                   (tied_to_ground_i),
        .REFCLKOUT                      (REFCLKOUT_OUT),
        .REFCLKPWRDNB                   (tied_to_vcc_i),
        .RESETDONE0                     (RESETDONE0_OUT),
        .RESETDONE1                     (RESETDONE1_OUT),
        //------------ Transmit Ports - 64b66b and 64b67b Gearbox Ports ------------
        .TXGEARBOXREADY0                (),
        .TXGEARBOXREADY1                (),
        .TXHEADER0                      (tied_to_ground_vec_i[2:0]),
        .TXHEADER1                      (tied_to_ground_vec_i[2:0]),
        .TXSEQUENCE0                    (tied_to_ground_vec_i[6:0]),
        .TXSEQUENCE1                    (tied_to_ground_vec_i[6:0]),
        .TXSTARTSEQ0                    (tied_to_ground_i),
        .TXSTARTSEQ1                    (tied_to_ground_i),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .TXBYPASS8B10B0                 (tied_to_ground_vec_i[3:0]),
        .TXBYPASS8B10B1                 (tied_to_ground_vec_i[3:0]),
        .TXCHARDISPMODE0                (tied_to_ground_vec_i[3:0]),
        .TXCHARDISPMODE1                (tied_to_ground_vec_i[3:0]),
        .TXCHARDISPVAL0                 (tied_to_ground_vec_i[3:0]),
        .TXCHARDISPVAL1                 (tied_to_ground_vec_i[3:0]),
        .TXCHARISK0                     ({tied_to_ground_vec_i[1:0],TXCHARISK0_IN}),
        .TXCHARISK1                     ({tied_to_ground_vec_i[1:0],TXCHARISK1_IN}),
        .TXENC8B10BUSE0                 (tied_to_vcc_i),
        .TXENC8B10BUSE1                 (tied_to_vcc_i),
        .TXKERR0                        (),
        .TXKERR1                        (),
        .TXRUNDISP0                     (),
        .TXRUNDISP1                     (),
        //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
        .TXBUFSTATUS0                   (),
        .TXBUFSTATUS1                   (),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA0                        (txdata0_i),
        .TXDATA1                        (txdata1_i),
        .TXDATAWIDTH0                   (2'b01),
        .TXDATAWIDTH1                   (2'b01),
        .TXOUTCLK0                      (),
        .TXOUTCLK1                      (),
        .TXRESET0                       (TXRESET0_IN),
        .TXRESET1                       (TXRESET1_IN),
        .TXUSRCLK0                      (TXUSRCLK0_IN),
        .TXUSRCLK1                      (TXUSRCLK1_IN),
        .TXUSRCLK20                     (TXUSRCLK20_IN),
        .TXUSRCLK21                     (TXUSRCLK21_IN),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TXBUFDIFFCTRL0                 (3'b101),
        .TXBUFDIFFCTRL1                 (3'b101),
        .TXDIFFCTRL0                    (3'b000),
        .TXDIFFCTRL1                    (3'b000),
        .TXINHIBIT0                     (tied_to_ground_i),
        .TXINHIBIT1                     (tied_to_ground_i),
        .TXN0                           (TXN0_OUT),
        .TXN1                           (TXN1_OUT),
        .TXP0                           (TXP0_OUT),
        .TXP1                           (TXP1_OUT),
        .TXPREEMPHASIS0                 (4'b0000),
        .TXPREEMPHASIS1                 (4'b0000),
        //------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .TXENPMAPHASEALIGN0             (TXENPMAPHASEALIGN0_IN),
        .TXENPMAPHASEALIGN1             (TXENPMAPHASEALIGN1_IN),
        .TXPMASETPHASE0                 (TXPMASETPHASE0_IN),
        .TXPMASETPHASE1                 (TXPMASETPHASE1_IN),
        //------------------- Transmit Ports - TX PRBS Generator -------------------
        .TXENPRBSTST0                   (tied_to_ground_vec_i[1:0]),
        .TXENPRBSTST1                   (tied_to_ground_vec_i[1:0]),
        //------------------ Transmit Ports - TX Polarity Control ------------------
        .TXPOLARITY0                    (tied_to_ground_i),
        .TXPOLARITY1                    (tied_to_ground_i),
        //--------------- Transmit Ports - TX Ports for PCI Express ----------------
        .TXDETECTRX0                    (tied_to_ground_i),
        .TXDETECTRX1                    (tied_to_ground_i),
        .TXELECIDLE0                    (TXELECIDLE0_IN),
        .TXELECIDLE1                    (TXELECIDLE1_IN),
        //------------------- Transmit Ports - TX Ports for SATA -------------------
        .TXCOMSTART0                    (tied_to_ground_i),
        .TXCOMSTART1                    (tied_to_ground_i),
        .TXCOMTYPE0                     (tied_to_ground_i),
        .TXCOMTYPE1                     (tied_to_ground_i)

     );
     
     end
     else begin: USE_REVERSE_LANES
     
         //------------------------- GTX Instantiations  --------------------------

    GTX_DUAL #
    (
        //_______________________ Simulation-Only Attributes __________________

        .SIM_RECEIVER_DETECT_PASS_0  ("TRUE"),
        .SIM_RECEIVER_DETECT_PASS_1  ("TRUE"),
        .SIM_MODE                    (TILE_SIM_MODE),
        .SIM_GTXRESET_SPEEDUP        (TILE_SIM_GTXRESET_SPEEDUP),
        .SIM_PLL_PERDIV2             (TILE_SIM_PLL_PERDIV2),

        //___________________________ Shared Attributes _______________________

        //---------------------- Tile and PLL Attributes ----------------------

        .CLK25_DIVIDER               (10),
        .CLKINDC_B                   ("TRUE"),
        .CLKRCV_TRST                 ("TRUE"),
        .OOB_CLK_DIVIDER             (6),
        .OVERSAMPLE_MODE             ("FALSE"),
        .PLL_COM_CFG                 (24'h21680a),
        .PLL_CP_CFG                  (8'h00),
        .PLL_DIVSEL_FB               (2),
        .PLL_DIVSEL_REF              (1),
        .PLL_FB_DCCEN                ("FALSE"),
        .PLL_LKDET_CFG               (3'b101),
        .PLL_TDCC_CFG                (3'b000),
        .PMA_COM_CFG                 (69'h000000000000000000),

        //______________________ Transmit Interface Attributes ________________


        //----------------- TX Buffering and Phase Alignment ------------------

        .TX_BUFFER_USE_0            ("TRUE"),
        .TX_XCLK_SEL_0              ("TXOUT"),
        .TXRX_INVERT_0              (3'b011),

        .TX_BUFFER_USE_1            ("TRUE"),
        .TX_XCLK_SEL_1              ("TXOUT"),
        .TXRX_INVERT_1              (3'b011),

        //------------------- TX Gearbox Settings -----------------------------

        .GEARBOX_ENDEC_0            (3'b000),
        .TXGEARBOX_USE_0            ("FALSE"),

        .GEARBOX_ENDEC_1            (3'b000),
        .TXGEARBOX_USE_1            ("FALSE"),

        //------------------- TX Serial Line Rate settings --------------------

        .PLL_TXDIVSEL_OUT_0         (1),

        .PLL_TXDIVSEL_OUT_1         (1),

        //------------------- TX Driver and OOB signalling --------------------

        .CM_TRIM_0                 (2'b10),
        .PMA_TX_CFG_0              (20'h80082),
        .TX_DETECT_RX_CFG_0        (14'h1832),
        .TX_IDLE_DELAY_0           (3'b010),

        .CM_TRIM_1                 (2'b10),
        .PMA_TX_CFG_1              (20'h80082),
        .TX_DETECT_RX_CFG_1        (14'h1832),
        .TX_IDLE_DELAY_1           (3'b010),

        //---------------- TX Pipe Control for PCI Express/SATA ---------------

        .COM_BURST_VAL_0            (4'b1111),

        .COM_BURST_VAL_1            (4'b1111),

        //_______________________ Receive Interface Attributes ________________


        //---------- RX Driver,OOB signalling,Coupling and Eq.,CDR ------------

        .AC_CAP_DIS_0               ("TRUE"),
        .OOBDETECT_THRESHOLD_0      (3'b111),
        .PMA_CDR_SCAN_0             (27'h640403a),
        .PMA_RX_CFG_0               (25'h0f44088),
        .RCV_TERM_GND_0             ("FALSE"),
        .RCV_TERM_VTTRX_0           ("FALSE"),
        .TERMINATION_IMP_0          (50),

        .AC_CAP_DIS_1               ("TRUE"),
        .OOBDETECT_THRESHOLD_1      (3'b111),
        .PMA_CDR_SCAN_1             (27'h640403a),
        .PMA_RX_CFG_1               (25'h0f44088),
        .RCV_TERM_GND_1             ("FALSE"),
        .RCV_TERM_VTTRX_1           ("FALSE"),
        .TERMINATION_IMP_1          (50),

        .TERMINATION_CTRL           (5'b10100),
        .TERMINATION_OVRD           ("FALSE"),

        //-------------- RX Decision Feedback Equalizer(DFE)  ----------------

        .DFE_CFG_0                  (10'b1001111011),

        .DFE_CFG_1                  (10'b1001111011),

        .DFE_CAL_TIME               (5'b00110),

        //------------------- RX Serial Line Rate Settings --------------------

        .PLL_RXDIVSEL_OUT_0         (1),
        .PLL_SATA_0                 ("FALSE"),

        .PLL_RXDIVSEL_OUT_1         (1),
        .PLL_SATA_1                 ("FALSE"),


        //------------------------- PRBS Detection ----------------------------

        .PRBS_ERR_THRESHOLD_0       (32'h00000001),

        .PRBS_ERR_THRESHOLD_1       (32'h00000001),

        //------------------- Comma Detection and Alignment -------------------

        .ALIGN_COMMA_WORD_0         (1),
        .COMMA_10B_ENABLE_0         (10'b0001111111),
        .COMMA_DOUBLE_0             ("FALSE"),
        .DEC_MCOMMA_DETECT_0        ("TRUE"),
        .DEC_PCOMMA_DETECT_0        ("TRUE"),
        .DEC_VALID_COMMA_ONLY_0     ("TRUE"),
        .MCOMMA_10B_VALUE_0         (10'b1010000011),
        .MCOMMA_DETECT_0            ("TRUE"),
        .PCOMMA_10B_VALUE_0         (10'b0101111100),
        .PCOMMA_DETECT_0            ("TRUE"),
        .RX_SLIDE_MODE_0            ("PCS"),

        .ALIGN_COMMA_WORD_1         (1),
        .COMMA_10B_ENABLE_1         (10'b0001111111),
        .COMMA_DOUBLE_1             ("FALSE"),
        .DEC_MCOMMA_DETECT_1        ("TRUE"),
        .DEC_PCOMMA_DETECT_1        ("TRUE"),
        .DEC_VALID_COMMA_ONLY_1     ("TRUE"),
        .MCOMMA_10B_VALUE_1         (10'b1010000011),
        .MCOMMA_DETECT_1            ("TRUE"),
        .PCOMMA_10B_VALUE_1         (10'b0101111100),
        .PCOMMA_DETECT_1            ("TRUE"),
        .RX_SLIDE_MODE_1            ("PCS"),


        //------------------- RX Loss-of-sync State Machine -------------------
        .RX_LOSS_OF_SYNC_FSM_0      ("TRUE"),
        .RX_LOS_INVALID_INCR_0      (1),
        .RX_LOS_THRESHOLD_0         (4),

        .RX_LOSS_OF_SYNC_FSM_1      ("TRUE"),
        .RX_LOS_INVALID_INCR_1      (1),
        .RX_LOS_THRESHOLD_1         (4),

        //------------------- RX Gearbox Settings -----------------------------

        .RXGEARBOX_USE_0            ("FALSE"),

        .RXGEARBOX_USE_1            ("FALSE"),

        //------------ RX Elastic Buffer and Phase alignment ports ------------

        .PMA_RXSYNC_CFG_0           (7'h00),
        .RX_BUFFER_USE_0            ("TRUE"),
        .RX_XCLK_SEL_0              ("RXREC"),

        .PMA_RXSYNC_CFG_1           (7'h00),
        .RX_BUFFER_USE_1            ("TRUE"),
        .RX_XCLK_SEL_1              ("RXREC"),

        //--------------------- Clock Correction Attributes -------------------

        .CLK_CORRECT_USE_0          ("FALSE"),
        .CLK_COR_ADJ_LEN_0          (1),
        .CLK_COR_DET_LEN_0          (1),
        .CLK_COR_INSERT_IDLE_FLAG_0 ("FALSE"),
        .CLK_COR_KEEP_IDLE_0        ("FALSE"),
        .CLK_COR_MAX_LAT_0          (20),
        .CLK_COR_MIN_LAT_0          (18),
        .CLK_COR_PRECEDENCE_0       ("TRUE"),
        .CLK_COR_REPEAT_WAIT_0      (0),
        .CLK_COR_SEQ_1_1_0          (10'b0100000000),
        .CLK_COR_SEQ_1_2_0          (10'b0000000000),
        .CLK_COR_SEQ_1_3_0          (10'b0000000000),
        .CLK_COR_SEQ_1_4_0          (10'b0000000000),
        .CLK_COR_SEQ_1_ENABLE_0     (4'b1111),
        .CLK_COR_SEQ_2_1_0          (10'b0100000000),
        .CLK_COR_SEQ_2_2_0          (10'b0000000000),
        .CLK_COR_SEQ_2_3_0          (10'b0000000000),
        .CLK_COR_SEQ_2_4_0          (10'b0000000000),
        .CLK_COR_SEQ_2_ENABLE_0     (4'b1111),
        .CLK_COR_SEQ_2_USE_0        ("FALSE"),
        .RX_DECODE_SEQ_MATCH_0      ("TRUE"),

        .CLK_CORRECT_USE_1          ("FALSE"),
        .CLK_COR_ADJ_LEN_1          (1),
        .CLK_COR_DET_LEN_1          (1),
        .CLK_COR_INSERT_IDLE_FLAG_1 ("FALSE"),
        .CLK_COR_KEEP_IDLE_1        ("FALSE"),
        .CLK_COR_MAX_LAT_1          (20),
        .CLK_COR_MIN_LAT_1          (18),
        .CLK_COR_PRECEDENCE_1       ("TRUE"),
        .CLK_COR_REPEAT_WAIT_1      (0),
        .CLK_COR_SEQ_1_1_1          (10'b0100000000),
        .CLK_COR_SEQ_1_2_1          (10'b0000000000),
        .CLK_COR_SEQ_1_3_1          (10'b0000000000),
        .CLK_COR_SEQ_1_4_1          (10'b0000000000),
        .CLK_COR_SEQ_1_ENABLE_1     (4'b1111),
        .CLK_COR_SEQ_2_1_1          (10'b0100000000),
        .CLK_COR_SEQ_2_2_1          (10'b0000000000),
        .CLK_COR_SEQ_2_3_1          (10'b0000000000),
        .CLK_COR_SEQ_2_4_1          (10'b0000000000),
        .CLK_COR_SEQ_2_ENABLE_1     (4'b1111),
        .CLK_COR_SEQ_2_USE_1        ("FALSE"),
        .RX_DECODE_SEQ_MATCH_1      ("TRUE"),

        //-------------------- Channel Bonding Attributes ---------------------

        .CB2_INH_CC_PERIOD_0        (8),
        .CHAN_BOND_1_MAX_SKEW_0     (7),
        .CHAN_BOND_2_MAX_SKEW_0     (1),
        .CHAN_BOND_KEEP_ALIGN_0     ("FALSE"),
        .CHAN_BOND_LEVEL_1          (TILE_CHAN_BOND_LEVEL_0),
        .CHAN_BOND_MODE_1           (TILE_CHAN_BOND_MODE_0),
        .CHAN_BOND_SEQ_1_1_0        (10'b0101111100),
        .CHAN_BOND_SEQ_1_2_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_3_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_4_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_ENABLE_0   (4'b0001),
        .CHAN_BOND_SEQ_2_1_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_2_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_3_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_4_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_ENABLE_0   (4'b0000),
        .CHAN_BOND_SEQ_2_USE_0      ("FALSE"),
        .CHAN_BOND_SEQ_LEN_0        (1),
        .PCI_EXPRESS_MODE_0         ("FALSE"),

        .CB2_INH_CC_PERIOD_1        (8),
        .CHAN_BOND_1_MAX_SKEW_1     (7),
        .CHAN_BOND_2_MAX_SKEW_1     (1),
        .CHAN_BOND_KEEP_ALIGN_1     ("FALSE"),
        .CHAN_BOND_LEVEL_0          (TILE_CHAN_BOND_LEVEL_1),
        .CHAN_BOND_MODE_0           (TILE_CHAN_BOND_MODE_1),
        .CHAN_BOND_SEQ_1_1_1        (10'b0101111100),
        .CHAN_BOND_SEQ_1_2_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_3_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_4_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_ENABLE_1   (4'b0001),
        .CHAN_BOND_SEQ_2_1_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_2_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_3_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_4_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_ENABLE_1   (4'b0000),
        .CHAN_BOND_SEQ_2_USE_1      ("FALSE"),
        .CHAN_BOND_SEQ_LEN_1        (1),
        .PCI_EXPRESS_MODE_1         ("FALSE"),

        //------ RX Attributes to Control Reset after Electrical Idle  ------

        .RX_EN_IDLE_HOLD_DFE_0      ("TRUE"),
        .RX_EN_IDLE_RESET_BUF_0     ("TRUE"),
        .RX_IDLE_HI_CNT_0           (4'b1000),
        .RX_IDLE_LO_CNT_0           (4'b0000),

        .RX_EN_IDLE_HOLD_DFE_1      ("TRUE"),
        .RX_EN_IDLE_RESET_BUF_1     ("TRUE"),
        .RX_IDLE_HI_CNT_1           (4'b1000),
        .RX_IDLE_LO_CNT_1           (4'b0000),


        .CDR_PH_ADJ_TIME            (5'b01010),
        .RX_EN_IDLE_RESET_FR        ("TRUE"),
        .RX_EN_IDLE_HOLD_CDR        ("FALSE"),
        .RX_EN_IDLE_RESET_PH        ("TRUE"),

        //---------------- RX Attributes for PCI Express/SATA ---------------

        .RX_STATUS_FMT_0            ("PCIE"),
        .SATA_BURST_VAL_0           (3'b100),
        .SATA_IDLE_VAL_0            (3'b100),
        .SATA_MAX_BURST_0           (7),
        .SATA_MAX_INIT_0            (22),
        .SATA_MAX_WAKE_0            (7),
        .SATA_MIN_BURST_0           (4),
        .SATA_MIN_INIT_0            (12),
        .SATA_MIN_WAKE_0            (4),
        .TRANS_TIME_FROM_P2_0       (16'h003c),
        .TRANS_TIME_NON_P2_0        (16'h0019),
        .TRANS_TIME_TO_P2_0         (16'h0064),

        .RX_STATUS_FMT_1            ("PCIE"),
        .SATA_BURST_VAL_1           (3'b100),
        .SATA_IDLE_VAL_1            (3'b100),
        .SATA_MAX_BURST_1           (7),
        .SATA_MAX_INIT_1            (22),
        .SATA_MAX_WAKE_1            (7),
        .SATA_MIN_BURST_1           (4),
        .SATA_MIN_INIT_1            (12),
        .SATA_MIN_WAKE_1            (4),
        .TRANS_TIME_FROM_P2_1       (16'h003c),
        .TRANS_TIME_NON_P2_1        (16'h0019),
        .TRANS_TIME_TO_P2_1         (16'h0064)
     )
     gtx_dual_i
     (

        //---------------------- Loopback and Powerdown Ports ----------------------
        .LOOPBACK1                      (LOOPBACK0_IN),
        .LOOPBACK0                      (LOOPBACK1_IN),
        .RXPOWERDOWN1                   (RXPOWERDOWN0_IN),
        .RXPOWERDOWN0                   (RXPOWERDOWN1_IN),
        .TXPOWERDOWN1                   (TXPOWERDOWN0_IN),
        .TXPOWERDOWN0                   (TXPOWERDOWN1_IN),
        //------------ Receive Ports - 64b66b and 64b67b Gearbox Ports -------------
        .RXDATAVALID0                   (),
        .RXDATAVALID1                   (),
        .RXGEARBOXSLIP0                 (tied_to_ground_i),
        .RXGEARBOXSLIP1                 (tied_to_ground_i),
        .RXHEADER0                      (),
        .RXHEADER1                      (),
        .RXHEADERVALID0                 (),
        .RXHEADERVALID1                 (),
        .RXSTARTOFSEQ0                  (),
        .RXSTARTOFSEQ1                  (),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .RXCHARISCOMMA1                 ({rxchariscomma0_float_i,RXCHARISCOMMA0_OUT}),
        .RXCHARISCOMMA0                 ({rxchariscomma1_float_i,RXCHARISCOMMA1_OUT}),
        .RXCHARISK1                     ({rxcharisk0_float_i,RXCHARISK0_OUT}),
        .RXCHARISK0                     ({rxcharisk1_float_i,RXCHARISK1_OUT}),
        .RXDEC8B10BUSE0                 (tied_to_vcc_i),
        .RXDEC8B10BUSE1                 (tied_to_vcc_i),
        .RXDISPERR1                     ({rxdisperr0_float_i,RXDISPERR0_OUT}),
        .RXDISPERR0                     ({rxdisperr1_float_i,RXDISPERR1_OUT}),
        .RXNOTINTABLE1                  ({rxnotintable0_float_i,RXNOTINTABLE0_OUT}),
        .RXNOTINTABLE0                  ({rxnotintable1_float_i,RXNOTINTABLE1_OUT}),
        .RXRUNDISP1                     ({rxrundisp0_float_i,RXRUNDISP0_OUT}),
        .RXRUNDISP0                     ({rxrundisp1_float_i,RXRUNDISP1_OUT}),
        //----------------- Receive Ports - Channel Bonding Ports ------------------
        .RXCHANBONDSEQ1                 (RXCHANBONDSEQ0_OUT),
        .RXCHANBONDSEQ0                 (RXCHANBONDSEQ1_OUT),
        .RXCHBONDI1                     (RXCHBONDI0_IN),
        .RXCHBONDI0                     (RXCHBONDI1_IN),
        .RXCHBONDO1                     (RXCHBONDO0_OUT),
        .RXCHBONDO0                     (RXCHBONDO1_OUT),
        .RXENCHANSYNC1                  (RXENCHANSYNC0_IN),
        .RXENCHANSYNC0                  (RXENCHANSYNC1_IN),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .RXCLKCORCNT1                   (RXCLKCORCNT0_OUT),
        .RXCLKCORCNT0                   (RXCLKCORCNT1_OUT),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .RXBYTEISALIGNED1               (RXBYTEISALIGNED0_OUT),
        .RXBYTEISALIGNED0               (RXBYTEISALIGNED1_OUT),
        .RXBYTEREALIGN1                 (RXBYTEREALIGN0_OUT),
        .RXBYTEREALIGN0                 (RXBYTEREALIGN1_OUT),
        .RXCOMMADET1                    (RXCOMMADET0_OUT),
        .RXCOMMADET0                    (RXCOMMADET1_OUT),
        .RXCOMMADETUSE0                 (tied_to_vcc_i),
        .RXCOMMADETUSE1                 (tied_to_vcc_i),
        .RXENMCOMMAALIGN1               (RXENMCOMMAALIGN0_IN),
        .RXENMCOMMAALIGN0               (RXENMCOMMAALIGN1_IN),
        .RXENPCOMMAALIGN1               (RXENPCOMMAALIGN0_IN),
        .RXENPCOMMAALIGN0               (RXENPCOMMAALIGN1_IN),
        .RXSLIDE0                       (tied_to_ground_i),
        .RXSLIDE1                       (tied_to_ground_i),
        //--------------------- Receive Ports - PRBS Detection ---------------------
        .PRBSCNTRESET0                  (tied_to_ground_i),
        .PRBSCNTRESET1                  (tied_to_ground_i),
        .RXENPRBSTST0                   (tied_to_ground_vec_i[1:0]),
        .RXENPRBSTST1                   (tied_to_ground_vec_i[1:0]),
        .RXPRBSERR0                     (),
        .RXPRBSERR1                     (),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .RXDATA1                        (rxdata0_i),
        .RXDATA0                        (rxdata1_i),
        .RXDATAWIDTH0                   (2'b01),
        .RXDATAWIDTH1                   (2'b01),
        .RXRECCLK1                      (RXRECCLK0_OUT),
        .RXRECCLK0                      (RXRECCLK1_OUT),
        .RXRESET1                       (RXRESET0_IN),
        .RXRESET0                       (RXRESET1_IN),
        .RXUSRCLK1                      (RXUSRCLK0_IN),
        .RXUSRCLK0                      (RXUSRCLK1_IN),
        .RXUSRCLK21                     (RXUSRCLK20_IN),
        .RXUSRCLK20                     (RXUSRCLK21_IN),
        //---------- Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
        .DFECLKDLYADJ0                  (tied_to_ground_vec_i[5:0]),
        .DFECLKDLYADJ1                  (tied_to_ground_vec_i[5:0]),
        .DFECLKDLYADJMONITOR0           (),
        .DFECLKDLYADJMONITOR1           (),
        .DFEEYEDACMONITOR0              (),
        .DFEEYEDACMONITOR1              (),
        .DFESENSCAL0                    (),
        .DFESENSCAL1                    (),
        .DFETAP10                       (tied_to_ground_vec_i[4:0]),
        .DFETAP11                       (tied_to_ground_vec_i[4:0]),
        .DFETAP1MONITOR0                (),
        .DFETAP1MONITOR1                (),
        .DFETAP20                       (tied_to_ground_vec_i[4:0]),
        .DFETAP21                       (tied_to_ground_vec_i[4:0]),
        .DFETAP2MONITOR0                (),
        .DFETAP2MONITOR1                (),
        .DFETAP30                       (tied_to_ground_vec_i[3:0]),
        .DFETAP31                       (tied_to_ground_vec_i[3:0]),
        .DFETAP3MONITOR0                (),
        .DFETAP3MONITOR1                (),
        .DFETAP40                       (tied_to_ground_vec_i[3:0]),
        .DFETAP41                       (tied_to_ground_vec_i[3:0]),
        .DFETAP4MONITOR0                (),
        .DFETAP4MONITOR1                (),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .RXCDRRESET1                    (RXCDRRESET0_IN),
        .RXCDRRESET0                    (RXCDRRESET1_IN),
        .RXELECIDLE1                    (RXELECIDLE0_OUT),
        .RXELECIDLE0                    (RXELECIDLE1_OUT),
        .RXENEQB0                       (tied_to_ground_i),
        .RXENEQB1                       (tied_to_ground_i),
        .RXEQMIX0                       (2'b11),
        .RXEQMIX1                       (2'b11),
        .RXEQPOLE0                      (4'b0000),
        .RXEQPOLE1                      (4'b0000),
        .RXN1                           (RXN0_IN),
        .RXN0                           (RXN1_IN),
        .RXP1                           (RXP0_IN),
        .RXP0                           (RXP1_IN),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .RXBUFRESET1                    (RXBUFRESET0_IN),
        .RXBUFRESET0                    (RXBUFRESET1_IN),
        .RXBUFSTATUS1                   (RXBUFSTATUS0_OUT),
        .RXBUFSTATUS0                   (RXBUFSTATUS1_OUT),
        .RXCHANISALIGNED1               (RXCHANISALIGNED0_OUT),
        .RXCHANISALIGNED0               (RXCHANISALIGNED1_OUT),
        .RXCHANREALIGN1                 (RXCHANREALIGN0_OUT),
        .RXCHANREALIGN0                 (RXCHANREALIGN1_OUT),
        .RXENPMAPHASEALIGN0             (tied_to_ground_i),
        .RXENPMAPHASEALIGN1             (tied_to_ground_i),
        .RXPMASETPHASE0                 (tied_to_ground_i),
        .RXPMASETPHASE1                 (tied_to_ground_i),
        .RXSTATUS0                      (),
        .RXSTATUS1                      (),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .RXLOSSOFSYNC1                  (RXLOSSOFSYNC0_OUT),
        .RXLOSSOFSYNC0                  (RXLOSSOFSYNC1_OUT),
        //-------------------- Receive Ports - RX Oversampling ---------------------
        .RXENSAMPLEALIGN0               (tied_to_ground_i),
        .RXENSAMPLEALIGN1               (tied_to_ground_i),
        .RXOVERSAMPLEERR0               (),
        .RXOVERSAMPLEERR1               (),
        //------------ Receive Ports - RX Pipe Control for PCI Express -------------
        .PHYSTATUS0                     (),
        .PHYSTATUS1                     (),
        .RXVALID1                       (RXVALID0_OUT),
        .RXVALID0                       (RXVALID1_OUT),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .RXPOLARITY0                    (tied_to_ground_i),
        .RXPOLARITY1                    (tied_to_ground_i),
        //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
        .DADDR                          (DADDR_IN),
        .DCLK                           (DCLK_IN),
        .DEN                            (DEN_IN),
        .DI                             (DI_IN),
        .DO                             (DO_OUT),
        .DRDY                           (DRDY_OUT),
        .DWE                            (DWE_IN),
        //------------------- Shared Ports - Tile and PLL Ports --------------------
        .CLKIN                          (CLKIN_IN),
        .GTXRESET                       (GTXRESET_IN),
        .GTXTEST                        (14'b10000000000000),
        .INTDATAWIDTH                   (tied_to_vcc_i),
        .PLLLKDET                       (PLLLKDET_OUT),
        .PLLLKDETEN                     (tied_to_vcc_i),
        .PLLPOWERDOWN                   (tied_to_ground_i),
        .REFCLKOUT                      (REFCLKOUT_OUT),
        .REFCLKPWRDNB                   (tied_to_vcc_i),
        .RESETDONE1                     (RESETDONE0_OUT),
        .RESETDONE0                     (RESETDONE1_OUT),
        //------------ Transmit Ports - 64b66b and 64b67b Gearbox Ports ------------
        .TXGEARBOXREADY0                (),
        .TXGEARBOXREADY1                (),
        .TXHEADER0                      (tied_to_ground_vec_i[2:0]),
        .TXHEADER1                      (tied_to_ground_vec_i[2:0]),
        .TXSEQUENCE0                    (tied_to_ground_vec_i[6:0]),
        .TXSEQUENCE1                    (tied_to_ground_vec_i[6:0]),
        .TXSTARTSEQ0                    (tied_to_ground_i),
        .TXSTARTSEQ1                    (tied_to_ground_i),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .TXBYPASS8B10B0                 (tied_to_ground_vec_i[3:0]),
        .TXBYPASS8B10B1                 (tied_to_ground_vec_i[3:0]),
        .TXCHARDISPMODE0                (tied_to_ground_vec_i[3:0]),
        .TXCHARDISPMODE1                (tied_to_ground_vec_i[3:0]),
        .TXCHARDISPVAL0                 (tied_to_ground_vec_i[3:0]),
        .TXCHARDISPVAL1                 (tied_to_ground_vec_i[3:0]),
        .TXCHARISK1                     ({tied_to_ground_vec_i[1:0],TXCHARISK0_IN}),
        .TXCHARISK0                     ({tied_to_ground_vec_i[1:0],TXCHARISK1_IN}),
        .TXENC8B10BUSE0                 (tied_to_vcc_i),
        .TXENC8B10BUSE1                 (tied_to_vcc_i),
        .TXKERR0                        (),
        .TXKERR1                        (),
        .TXRUNDISP0                     (),
        .TXRUNDISP1                     (),
        //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
        .TXBUFSTATUS0                   (),
        .TXBUFSTATUS1                   (),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA1                        (txdata0_i),
        .TXDATA0                        (txdata1_i),
        .TXDATAWIDTH0                   (2'b01),
        .TXDATAWIDTH1                   (2'b01),
        .TXOUTCLK0                      (),
        .TXOUTCLK1                      (),
        .TXRESET1                       (TXRESET0_IN),
        .TXRESET0                       (TXRESET1_IN),
        .TXUSRCLK1                      (TXUSRCLK0_IN),
        .TXUSRCLK0                      (TXUSRCLK1_IN),
        .TXUSRCLK21                     (TXUSRCLK20_IN),
        .TXUSRCLK20                     (TXUSRCLK21_IN),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TXBUFDIFFCTRL0                 (3'b101),
        .TXBUFDIFFCTRL1                 (3'b101),
        .TXDIFFCTRL0                    (3'b000),
        .TXDIFFCTRL1                    (3'b000),
        .TXINHIBIT0                     (tied_to_ground_i),
        .TXINHIBIT1                     (tied_to_ground_i),
        .TXN1                           (TXN0_OUT),
        .TXN0                           (TXN1_OUT),
        .TXP1                           (TXP0_OUT),
        .TXP0                           (TXP1_OUT),
        .TXPREEMPHASIS0                 (4'b0000),
        .TXPREEMPHASIS1                 (4'b0000),
        //------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .TXENPMAPHASEALIGN1             (TXENPMAPHASEALIGN0_IN),
        .TXENPMAPHASEALIGN0             (TXENPMAPHASEALIGN1_IN),
        .TXPMASETPHASE1                 (TXPMASETPHASE0_IN),
        .TXPMASETPHASE0                 (TXPMASETPHASE1_IN),
        //------------------- Transmit Ports - TX PRBS Generator -------------------
        .TXENPRBSTST0                   (tied_to_ground_vec_i[1:0]),
        .TXENPRBSTST1                   (tied_to_ground_vec_i[1:0]),
        //------------------ Transmit Ports - TX Polarity Control ------------------
        .TXPOLARITY0                    (tied_to_ground_i),
        .TXPOLARITY1                    (tied_to_ground_i),
        //--------------- Transmit Ports - TX Ports for PCI Express ----------------
        .TXDETECTRX0                    (tied_to_ground_i),
        .TXDETECTRX1                    (tied_to_ground_i),
        .TXELECIDLE1                    (TXELECIDLE0_IN),
        .TXELECIDLE0                    (TXELECIDLE1_IN),
        //------------------- Transmit Ports - TX Ports for SATA -------------------
        .TXCOMSTART0                    (tied_to_ground_i),
        .TXCOMSTART1                    (tied_to_ground_i),
        .TXCOMTYPE0                     (tied_to_ground_i),
        .TXCOMTYPE1                     (tied_to_ground_i)

     );

     end
     endgenerate







endmodule


