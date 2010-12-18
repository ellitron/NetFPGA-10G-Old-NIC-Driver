////////////////////////////////////////////////////////////////////////
//
//  NetFPGA-10G http://www.netfpga.org
//
//  Module:
//          rocketio_wrapper_gtx_tile
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

module ROCKETIO_WRAPPER_GTX_TILE #
(
    // Simulation attributes
    parameter   TILE_SIM_GTXRESET_SPEEDUP  =   0,      // Set to 1 to speed up sim reset
    parameter   TILE_SIM_PLL_PERDIV2       =   9'h0c8,    // Set to the VCO Unit Interval time
    
    // Channel bonding attributes
    parameter   TILE_CHAN_BOND_MODE_0      =   "OFF",  // "MASTER", "SLAVE", or "OFF"
    parameter   TILE_CHAN_BOND_LEVEL_0     =   0,      // 0 to 7. See UG for details
    
    parameter   TILE_CHAN_BOND_MODE_1      =   "OFF",  // "MASTER", "SLAVE", or "OFF"
    parameter   TILE_CHAN_BOND_LEVEL_1     =   0       // 0 to 7. See UG for details
)
(
    //---------------------- Loopback and Powerdown Ports ----------------------
    LOOPBACK0_IN,
    LOOPBACK1_IN,
    RXPOWERDOWN0_IN,
    TXPOWERDOWN0_IN,
    RXPOWERDOWN1_IN,
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
    //----------------- Receive Ports - Clock Correction Ports -----------------
    RXCLKCORCNT0_OUT,
    RXCLKCORCNT1_OUT,
    //------------- Receive Ports - Comma Detection and Alignment --------------
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
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    CLKIN_IN,
    GTXRESET_IN,
    PLLLKDET_OUT,
    REFCLKOUT_OUT,
    RESETDONE0_OUT,
    RESETDONE1_OUT,
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    TXCHARDISPMODE0_IN,
    TXCHARDISPMODE1_IN,
    TXCHARDISPVAL0_IN,
    TXCHARDISPVAL1_IN,
    TXCHARISK0_IN,
    TXCHARISK1_IN,
    //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
    TXBUFSTATUS0_OUT,
    TXBUFSTATUS1_OUT,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    TXDATA0_IN,
    TXDATA1_IN,
    TXOUTCLK0_OUT,
    TXOUTCLK1_OUT,
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
    TXP1_OUT


);

//***************************** Port Declarations *****************************
        

    //---------------------- Loopback and Powerdown Ports ----------------------
    input   [2:0]   LOOPBACK0_IN;
    input   [2:0]   LOOPBACK1_IN;
    input   [1:0]   RXPOWERDOWN0_IN;
    input   [1:0]   TXPOWERDOWN0_IN;
    input   [1:0]   RXPOWERDOWN1_IN;
    input   [1:0]   TXPOWERDOWN1_IN;
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    output          RXCHARISCOMMA0_OUT;    
    output          RXCHARISK0_OUT;    
    output          RXDISPERR0_OUT;    
    output          RXNOTINTABLE0_OUT;    
    output          RXRUNDISP0_OUT;
    output          RXCHARISCOMMA1_OUT;
    output          RXCHARISK1_OUT;
    output          RXDISPERR1_OUT;
    output          RXNOTINTABLE1_OUT;
    output          RXRUNDISP1_OUT;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    output  [2:0]   RXCLKCORCNT0_OUT;
    output  [2:0]   RXCLKCORCNT1_OUT;
    //------------- Receive Ports - Comma Detection and Alignment --------------
    input           RXENMCOMMAALIGN0_IN;
    input           RXENMCOMMAALIGN1_IN;
    input           RXENPCOMMAALIGN0_IN;
    input           RXENPCOMMAALIGN1_IN;
    //----------------- Receive Ports - RX Data Path interface -----------------
    output  [7:0]   RXDATA0_OUT;
    output  [7:0]   RXDATA1_OUT;
    output          RXRECCLK0_OUT;
    output          RXRECCLK1_OUT;
    input           RXRESET0_IN;
    input           RXRESET1_IN;
    input           RXUSRCLK0_IN;
    input           RXUSRCLK1_IN;
    input           RXUSRCLK20_IN;
    input           RXUSRCLK21_IN;
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
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
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    input           CLKIN_IN;
    input           GTXRESET_IN;
    output          PLLLKDET_OUT;
    output          REFCLKOUT_OUT;
    output          RESETDONE0_OUT;
    output          RESETDONE1_OUT;
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    input           TXCHARDISPMODE0_IN;
    input           TXCHARDISPMODE1_IN;
    input           TXCHARDISPVAL0_IN;
    input           TXCHARDISPVAL1_IN;
    input           TXCHARISK0_IN;
    input           TXCHARISK1_IN;
    //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
    output  [1:0]   TXBUFSTATUS0_OUT;
    output  [1:0]   TXBUFSTATUS1_OUT;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input   [7:0]   TXDATA0_IN;
    input   [7:0]   TXDATA1_IN;
    output          TXOUTCLK0_OUT;
    output          TXOUTCLK1_OUT;
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



//***************************** Wire Declarations *****************************

    // ground and vcc signals
    wire            tied_to_ground_i;
    wire    [63:0]  tied_to_ground_vec_i;
    wire            tied_to_vcc_i;
    wire    [63:0]  tied_to_vcc_vec_i;


   

    //RX Datapath signals
    wire    [31:0]  rxdata0_i;
    wire    [2:0]   rxchariscomma0_float_i;
    wire    [2:0]   rxcharisk0_float_i;
    wire    [2:0]   rxdisperr0_float_i;
    wire    [2:0]   rxnotintable0_float_i;
    wire    [2:0]   rxrundisp0_float_i;

    //TX Datapath signals
    wire    [31:0]  txdata0_i;           

   

    //RX Datapath signals
    wire    [31:0]  rxdata1_i;
    wire    [2:0]   rxchariscomma1_float_i;
    wire    [2:0]   rxcharisk1_float_i;
    wire    [2:0]   rxdisperr1_float_i;
    wire    [2:0]   rxnotintable1_float_i;
    wire    [2:0]   rxrundisp1_float_i;

    //TX Datapath signals
    wire    [31:0]  txdata1_i;           




// 
//********************************* Main Body of Code**************************
                       
    //-------------------------  Static signal Assigments ---------------------   

    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 64'hffffffffffffffff;
                                            

    //-------------------  GTP Datapath byte mapping  -----------------
    

    assign  RXDATA0_OUT    =   rxdata0_i[7:0];
    
    assign  txdata0_i      =   {tied_to_ground_vec_i[23:0],TXDATA0_IN};    

    assign  RXDATA1_OUT    =   rxdata1_i[7:0];
    
    assign  txdata1_i      =   {tied_to_ground_vec_i[23:0],TXDATA1_IN};    






    
    //------------------------- GTX Instantiations  --------------------------   

    GTX_DUAL # 
    (
        //_______________________ Simulation-Only Attributes __________________

        .SIM_GTXRESET_SPEEDUP        (TILE_SIM_GTXRESET_SPEEDUP),
        .SIM_PLL_PERDIV2             (TILE_SIM_PLL_PERDIV2),
        .SIM_MODE                    ("FAST"),
        .SIM_RECEIVER_DETECT_PASS_0  ("TRUE"),
        .SIM_RECEIVER_DETECT_PASS_1  ("TRUE"),

        //___________________________ Shared Attributes _______________________
         
        //---------------------- Tile and PLL Attributes ----------------------

        .CLK25_DIVIDER               (5), 
        .CLKINDC_B                   ("TRUE"),
        .CLKRCV_TRST                 ("TRUE"),
        .OOB_CLK_DIVIDER             (4),
        .OVERSAMPLE_MODE             ("FALSE"),
        .PLL_COM_CFG                 (24'h21680a),
        .PLL_CP_CFG                  (8'h00),
        .PLL_DIVSEL_FB               (4),
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

        .PLL_TXDIVSEL_OUT_0         (4),

        .PLL_TXDIVSEL_OUT_1         (4),
 

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
        .PMA_CDR_SCAN_0             (27'h6404035), 
        .PMA_RX_CFG_0               (25'h0f44088),
        .RCV_TERM_GND_0             ("FALSE"),
        .RCV_TERM_VTTRX_0           ("TRUE"),
        .TERMINATION_IMP_0          (50),

        .AC_CAP_DIS_1               ("TRUE"),
        .OOBDETECT_THRESHOLD_1      (3'b111),
        .PMA_CDR_SCAN_1             (27'h6404035), 
        .PMA_RX_CFG_1               (25'h0f44088),  
        .RCV_TERM_GND_1             ("FALSE"),
        .RCV_TERM_VTTRX_1           ("TRUE"),
        .TERMINATION_IMP_1          (50),

        .TERMINATION_CTRL           (5'b10100),
        .TERMINATION_OVRD           ("FALSE"),

        //-------------- RX Decision Feedback Equalizer(DFE)  ----------------  

        .DFE_CFG_0                  (10'b1001111011),
                  
        .DFE_CFG_1                  (10'b1001111011),

        .DFE_CAL_TIME               (5'b00110),

        //------------------- RX Serial Line Rate Settings --------------------   

        .PLL_RXDIVSEL_OUT_0         (4),
        .PLL_SATA_0                 ("FALSE"),

        .PLL_RXDIVSEL_OUT_1         (4),
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
        .DEC_VALID_COMMA_ONLY_0     ("FALSE"),
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
        .DEC_VALID_COMMA_ONLY_1     ("FALSE"),
        .MCOMMA_10B_VALUE_1         (10'b1010000011),
        .MCOMMA_DETECT_1            ("TRUE"),
        .PCOMMA_10B_VALUE_1         (10'b0101111100),
        .PCOMMA_DETECT_1            ("TRUE"),
        .RX_SLIDE_MODE_1            ("PCS"),


        //------------------- RX Loss-of-sync State Machine -------------------  

        .RX_LOSS_OF_SYNC_FSM_0      ("FALSE"),
        .RX_LOS_INVALID_INCR_0      (8),
        .RX_LOS_THRESHOLD_0         (128),

        .RX_LOSS_OF_SYNC_FSM_1      ("FALSE"),
        .RX_LOS_INVALID_INCR_1      (8),
        .RX_LOS_THRESHOLD_1         (128),

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

        .CLK_CORRECT_USE_0          ("TRUE"),
        .CLK_COR_ADJ_LEN_0          (2),
        .CLK_COR_DET_LEN_0          (2),
        .CLK_COR_INSERT_IDLE_FLAG_0 ("FALSE"),
        .CLK_COR_KEEP_IDLE_0        ("FALSE"),
        .CLK_COR_MAX_LAT_0          (20),
        .CLK_COR_MIN_LAT_0          (16),
        .CLK_COR_PRECEDENCE_0       ("TRUE"),
        .CLK_COR_REPEAT_WAIT_0      (0),
        .CLK_COR_SEQ_1_1_0          (10'b0110111100),
        .CLK_COR_SEQ_1_2_0          (10'b0001010000),
        .CLK_COR_SEQ_1_3_0          (10'b0000000000),
        .CLK_COR_SEQ_1_4_0          (10'b0000000000),
        .CLK_COR_SEQ_1_ENABLE_0     (4'b0011),
        .CLK_COR_SEQ_2_1_0          (10'b0110111100),
        .CLK_COR_SEQ_2_2_0          (10'b0010110101),
        .CLK_COR_SEQ_2_3_0          (10'b0000000000),
        .CLK_COR_SEQ_2_4_0          (10'b0000000000),
        .CLK_COR_SEQ_2_ENABLE_0     (4'b0011),
        .CLK_COR_SEQ_2_USE_0        ("TRUE"),
        .RX_DECODE_SEQ_MATCH_0      ("TRUE"),

        .CLK_CORRECT_USE_1          ("TRUE"),
        .CLK_COR_ADJ_LEN_1          (2),
        .CLK_COR_DET_LEN_1          (2),
        .CLK_COR_INSERT_IDLE_FLAG_1 ("FALSE"),
        .CLK_COR_KEEP_IDLE_1        ("FALSE"),
        .CLK_COR_MAX_LAT_1          (20),
        .CLK_COR_MIN_LAT_1          (16),
        .CLK_COR_PRECEDENCE_1       ("TRUE"),
        .CLK_COR_REPEAT_WAIT_1      (0),
        .CLK_COR_SEQ_1_1_1          (10'b0110111100),
        .CLK_COR_SEQ_1_2_1          (10'b0001010000),
        .CLK_COR_SEQ_1_3_1          (10'b0000000000),
        .CLK_COR_SEQ_1_4_1          (10'b0000000000),
        .CLK_COR_SEQ_1_ENABLE_1     (4'b0011),
        .CLK_COR_SEQ_2_1_1          (10'b0110111100),
        .CLK_COR_SEQ_2_2_1          (10'b0010110101),
        .CLK_COR_SEQ_2_3_1          (10'b0000000000),
        .CLK_COR_SEQ_2_4_1          (10'b0000000000),
        .CLK_COR_SEQ_2_ENABLE_1     (4'b0011),
        .CLK_COR_SEQ_2_USE_1        ("TRUE"),
        .RX_DECODE_SEQ_MATCH_1      ("TRUE"),

        //-------------------- Channel Bonding Attributes ---------------------   

        .CB2_INH_CC_PERIOD_0        (8),
        .CHAN_BOND_1_MAX_SKEW_0     (1),
        .CHAN_BOND_2_MAX_SKEW_0     (1),
        .CHAN_BOND_KEEP_ALIGN_0     ("FALSE"),
        .CHAN_BOND_LEVEL_0          (TILE_CHAN_BOND_LEVEL_0),
        .CHAN_BOND_MODE_0           (TILE_CHAN_BOND_MODE_0),
        .CHAN_BOND_SEQ_1_1_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_2_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_3_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_4_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_ENABLE_0   (4'b0000),
        .CHAN_BOND_SEQ_2_1_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_2_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_3_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_4_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_ENABLE_0   (4'b0000),
        .CHAN_BOND_SEQ_2_USE_0      ("FALSE"),  
        .CHAN_BOND_SEQ_LEN_0        (1),
        .PCI_EXPRESS_MODE_0         ("FALSE"),     
     
        .CB2_INH_CC_PERIOD_1        (8),
        .CHAN_BOND_1_MAX_SKEW_1     (1),
        .CHAN_BOND_2_MAX_SKEW_1     (1),
        .CHAN_BOND_KEEP_ALIGN_1     ("FALSE"),
        .CHAN_BOND_LEVEL_1          (TILE_CHAN_BOND_LEVEL_1),
        .CHAN_BOND_MODE_1           (TILE_CHAN_BOND_MODE_1),
        .CHAN_BOND_SEQ_1_1_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_2_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_3_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_4_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_ENABLE_1   (4'b0000),
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
        .SATA_MAX_BURST_0           (9),
        .SATA_MAX_INIT_0            (27),
        .SATA_MAX_WAKE_0            (9),
        .SATA_MIN_BURST_0           (5),
        .SATA_MIN_INIT_0            (15),
        .SATA_MIN_WAKE_0            (5),
        .TRANS_TIME_FROM_P2_0       (16'h003c),
        .TRANS_TIME_NON_P2_0        (16'h0019),
        .TRANS_TIME_TO_P2_0         (16'h0064),

        .RX_STATUS_FMT_1            ("PCIE"),
        .SATA_BURST_VAL_1           (3'b100),
        .SATA_IDLE_VAL_1            (3'b100),
        .SATA_MAX_BURST_1           (9),
        .SATA_MAX_INIT_1            (27),
        .SATA_MAX_WAKE_1            (9),
        .SATA_MIN_BURST_1           (5),
        .SATA_MIN_INIT_1            (15),
        .SATA_MIN_WAKE_1            (5),
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
        .RXCHANBONDSEQ0                 (),
        .RXCHANBONDSEQ1                 (),
        .RXCHBONDI0                     (tied_to_ground_vec_i[3:0]),
        .RXCHBONDI1                     (tied_to_ground_vec_i[3:0]),
        .RXCHBONDO0                     (),
        .RXCHBONDO1                     (),
        .RXENCHANSYNC0                  (tied_to_ground_i),
        .RXENCHANSYNC1                  (tied_to_ground_i),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .RXCLKCORCNT0                   (RXCLKCORCNT0_OUT),
        .RXCLKCORCNT1                   (RXCLKCORCNT1_OUT),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .RXBYTEISALIGNED0               (),
        .RXBYTEISALIGNED1               (),
        .RXBYTEREALIGN0                 (),
        .RXBYTEREALIGN1                 (),
        .RXCOMMADET0                    (),
        .RXCOMMADET1                    (),
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
        .RXDATAWIDTH0                   (2'b00),
        .RXDATAWIDTH1                   (2'b00),
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
        .RXCDRRESET0                    (tied_to_ground_i),
        .RXCDRRESET1                    (tied_to_ground_i),
        .RXELECIDLE0                    (RXELECIDLE0_OUT),
        .RXELECIDLE1                    (RXELECIDLE1_OUT),
        .RXENEQB0                       (tied_to_ground_i),
        .RXENEQB1                       (tied_to_ground_i),
        .RXEQMIX0                       (tied_to_vcc_vec_i[1:0]),
        .RXEQMIX1                       (tied_to_vcc_vec_i[1:0]),
        .RXEQPOLE0                      (tied_to_ground_vec_i[3:0]),
        .RXEQPOLE1                      (tied_to_ground_vec_i[3:0]),
        .RXN0                           (RXN0_IN),
        .RXN1                           (RXN1_IN),
        .RXP0                           (RXP0_IN),
        .RXP1                           (RXP1_IN),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .RXBUFRESET0                    (RXBUFRESET0_IN),
        .RXBUFRESET1                    (RXBUFRESET1_IN),
        .RXBUFSTATUS0                   (RXBUFSTATUS0_OUT),
        .RXBUFSTATUS1                   (RXBUFSTATUS1_OUT),
        .RXCHANISALIGNED0               (),
        .RXCHANISALIGNED1               (),
        .RXCHANREALIGN0                 (),
        .RXCHANREALIGN1                 (),
        .RXENPMAPHASEALIGN0             (tied_to_ground_i),
        .RXENPMAPHASEALIGN1             (tied_to_ground_i),
        .RXPMASETPHASE0                 (tied_to_ground_i),
        .RXPMASETPHASE1                 (tied_to_ground_i),
        .RXSTATUS0                      (),
        .RXSTATUS1                      (),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .RXLOSSOFSYNC0                  (),
        .RXLOSSOFSYNC1                  (),
        //-------------------- Receive Ports - RX Oversampling ---------------------
        .RXENSAMPLEALIGN0               (tied_to_ground_i),
        .RXENSAMPLEALIGN1               (tied_to_ground_i),
        .RXOVERSAMPLEERR0               (),
        .RXOVERSAMPLEERR1               (),
        //------------ Receive Ports - RX Pipe Control for PCI Express -------------
        .PHYSTATUS0                     (),
        .PHYSTATUS1                     (),
        .RXVALID0                       (),
        .RXVALID1                       (),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .RXPOLARITY0                    (tied_to_ground_i),
        .RXPOLARITY1                    (tied_to_ground_i),
        //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
        .DADDR                          (tied_to_ground_vec_i[6:0]),
        .DCLK                           (tied_to_ground_i),
        .DEN                            (tied_to_ground_i),
        .DI                             (tied_to_ground_vec_i[15:0]),
        .DO                             (),
        .DRDY                           (),
        .DWE                            (tied_to_ground_i),
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
        .TXCHARDISPMODE0                ({tied_to_ground_vec_i[2:0],TXCHARDISPMODE0_IN}),
        .TXCHARDISPMODE1                ({tied_to_ground_vec_i[2:0],TXCHARDISPMODE1_IN}),
        .TXCHARDISPVAL0                 ({tied_to_ground_vec_i[2:0],TXCHARDISPVAL0_IN}),
        .TXCHARDISPVAL1                 ({tied_to_ground_vec_i[2:0],TXCHARDISPVAL1_IN}),
        .TXCHARISK0                     ({tied_to_ground_vec_i[2:0],TXCHARISK0_IN}),
        .TXCHARISK1                     ({tied_to_ground_vec_i[2:0],TXCHARISK1_IN}),
        .TXENC8B10BUSE0                 (tied_to_vcc_i),
        .TXENC8B10BUSE1                 (tied_to_vcc_i),
        .TXKERR0                        (),
        .TXKERR1                        (),
        .TXRUNDISP0                     (),
        .TXRUNDISP1                     (),
        //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
        .TXBUFSTATUS0                   (TXBUFSTATUS0_OUT),
        .TXBUFSTATUS1                   (TXBUFSTATUS1_OUT),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA0                        (txdata0_i),
        .TXDATA1                        (txdata1_i),
        .TXDATAWIDTH0                   (2'b00),
        .TXDATAWIDTH1                   (2'b00),
        .TXOUTCLK0                      (TXOUTCLK0_OUT),
        .TXOUTCLK1                      (TXOUTCLK1_OUT),
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
        .TXENPMAPHASEALIGN0             (tied_to_ground_i),
        .TXENPMAPHASEALIGN1             (tied_to_ground_i),
        .TXPMASETPHASE0                 (tied_to_ground_i),
        .TXPMASETPHASE1                 (tied_to_ground_i),
        //------------------- Transmit Ports - TX PRBS Generator -------------------
        .TXENPRBSTST0                   (tied_to_ground_vec_i[1:0]),
        .TXENPRBSTST1                   (tied_to_ground_vec_i[1:0]),
        //------------------ Transmit Ports - TX Polarity Control ------------------
        .TXPOLARITY0                    (tied_to_ground_i),
        .TXPOLARITY1                    (tied_to_ground_i),
        //--------------- Transmit Ports - TX Ports for PCI Express ----------------
        .TXDETECTRX0                    (tied_to_ground_i),
        .TXDETECTRX1                    (tied_to_ground_i),
        .TXELECIDLE0                    (tied_to_ground_i),
        .TXELECIDLE1                    (tied_to_ground_i),
        //------------------- Transmit Ports - TX Ports for SATA -------------------
        .TXCOMSTART0                    (tied_to_ground_i),
        .TXCOMSTART1                    (tied_to_ground_i),
        .TXCOMTYPE0                     (tied_to_ground_i),
        .TXCOMTYPE1                     (tied_to_ground_i)

     );
     
endmodule
