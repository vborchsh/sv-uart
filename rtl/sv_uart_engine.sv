
/*



  parameter int DATA_WIDTH = 24;



  logic                  uart__iclk          ;
  logic                  uart__irst          ;
  logic [DATA_WIDTH-1:0] uart__m_axis_tdata  ;
  logic                  uart__m_axis_tvalid ;
  logic                  uart__m_axis_tready ;
  logic [DATA_WIDTH-1:0] uart__s_axis_tdata  ;
  logic                  uart__s_axis_tvalid ;
  logic                  uart__s_axis_tready ;
  logic           [15:0] uart__idivider      ;
  logic                  uart__otx           ;
  logic                  uart__irx           ;



  sv_uart_engine
  #(
    . DATA_WIDTH    (DATA_WIDTH      ) 
  )
  uart__
  (
    .iclk          (uart__iclk               ) ,
    .irst          (uart__irst               ) ,
    .m_axis_tdata  (uart__m_axis_tdata       ) ,
    .m_axis_tvalid (uart__m_axis_tvalid      ) ,
    .m_axis_tready (uart__m_axis_tready      ) ,
    .s_axis_tdata  (uart__s_axis_tdata       ) ,
    .s_axis_tvalid (uart__s_axis_tvalid      ) ,
    .s_axis_tready (uart__s_axis_tready      ) ,
    .idivider      (uart__idivider           ) ,
    .otx           (uart__otx                ) ,
    .irx           (uart__irx                ) 
  );


  assign uart__iclk          = '0;
  assign uart__irst          = '0;
  assign uart__m_axis_tready = '0;
  assign uart__s_axis_tdata  = '0;
  assign uart__s_axis_tvalid = '0;
  assign uart__idivider      = '0;
  assign uart__irx           = '0;



*/ 

//
// Project       : UART core
// Author        : Borshch Vladislav
// Contacts      : borchsh.vn@gmail.com
// Workfile      : sv_uart_engine.sv
// Description   : AXIstream UART engine module
//

module sv_uart_engine
#(
  parameter int DATA_WIDTH = 24 , // Must be divided by 8; >8
  parameter int RX_PIPE = 5 // debounce and metastability pipe
)
(
  input  logic                  iclk          ,
  input  logic                  irst          ,
  output logic [DATA_WIDTH-1:0] m_axis_tdata  ,
  output logic                  m_axis_tvalid ,
  input  logic                  m_axis_tready ,
  input  logic [DATA_WIDTH-1:0] s_axis_tdata  ,
  input  logic                  s_axis_tvalid ,
  output logic                  s_axis_tready ,
  input  logic           [15:0] idivider      ,
  output logic                  otx           ,
  input  logic                  irx           
);

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  localparam int WORD_WIDTH = 8;
  localparam int STOP_BITS  = 1;

  localparam int WORDS_NUM  = DATA_WIDTH/WORD_WIDTH;

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  logic                  tx__iclk          ;
  logic                  tx__irst          ;
  logic [WORD_WIDTH-1:0] tx__s_axis_tdata  ;
  logic                  tx__s_axis_tvalid ;
  logic                  tx__s_axis_tready ;
  logic           [15:0] tx__idivider      ;
  logic                  tx__otx           ;

  logic                  rx__iclk          ;
  logic                  rx__irst          ;
  logic [WORD_WIDTH-1:0] rx__m_axis_tdata  ;
  logic                  rx__m_axis_tvalid ;
  logic                  rx__m_axis_tready ;
  logic           [15:0] rx__idivider      ;
  logic                  rx__irx           ;

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  logic                          tx_busy;
  logic                          tvalid;
  logic                          val_data;
  logic         [DATA_WIDTH-1:0] tx_dat;
  logic [$clog2(DATA_WIDTH)-1:0] cnt_tx;

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  always_ff@(posedge iclk) begin
    if (irst)
      tx_busy <= 1'b0;
    else if (s_axis_tvalid && s_axis_tready)
      tx_busy <= 1'b1;
    else if (cnt_tx == WORDS_NUM-1 && tx__s_axis_tready)
      tx_busy <= 1'b0;

    tvalid <= tx_busy && tx__s_axis_tready;

    if (irst)
      cnt_tx <= '0;
    if (~tx_busy)
      cnt_tx <= '0;
    else if (val_data)
      cnt_tx <= cnt_tx + 1'b1;

    if (irst)
      tx_dat <= '0;
    if (s_axis_tvalid && s_axis_tready)
      tx_dat <= s_axis_tdata;
    else if (tx__s_axis_tready && tx__s_axis_tvalid)
      tx_dat <= tx_dat << 8 | 'h00;
  end

  assign val_data = tvalid && tx__s_axis_tready;

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  assign m_axis_tdata = rx__m_axis_tdata;
  assign m_axis_tvalid = rx__m_axis_tvalid;
  assign s_axis_tready = ~tx_busy;

  always_ff@(posedge iclk) begin
    otx <= tx__otx;
  end

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  assign rx__iclk          = iclk;
  assign rx__irst          = irst;
  assign rx__m_axis_tready = m_axis_tready;
  assign rx__idivider      = idivider;
  assign rx__irx           = irx;

  assign tx__iclk          = iclk;
  assign tx__irst          = irst;
  assign tx__s_axis_tdata  = tx_dat[$high(tx_dat):$high(tx_dat)-7];
  assign tx__s_axis_tvalid = tvalid && tx__s_axis_tready;
  assign tx__idivider      = idivider;

  sv_uart_rx
  #(
    . DATA_WIDTH    (WORD_WIDTH              ) ,
    . IN_PIPE       (RX_PIPE                 ) 
  )
  rx__
  (
    .iclk           (rx__iclk               ) ,
    .irst           (rx__irst               ) ,
    .m_axis_tdata   (rx__m_axis_tdata       ) ,
    .m_axis_tvalid  (rx__m_axis_tvalid      ) ,
    .m_axis_tready  (rx__m_axis_tready      ) ,
    .idivider       (rx__idivider           ) ,
    .irx            (rx__irx                ) 
  );

  sv_uart_tx
  #(
    . DATA_WIDTH    (WORD_WIDTH             ) ,
    . STOP_BITS     (STOP_BITS              ) 
  )
  tx__
  (
    .iclk           (tx__iclk               ) ,
    .irst           (tx__irst               ) ,
    .s_axis_tdata   (tx__s_axis_tdata       ) ,
    .s_axis_tvalid  (tx__s_axis_tvalid      ) ,
    .s_axis_tready  (tx__s_axis_tready      ) ,
    .idivider       (tx__idivider           ) ,
    .otx            (tx__otx                ) 
  );

endmodule
