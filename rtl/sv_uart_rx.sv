/*



  parameter int DATA_WIDTH = 8;
  parameter int IN_PIPE    = 5;



  logic                  rx__iclk          ;
  logic                  rx__irst          ;
  logic [DATA_WIDTH-1:0] rx__m_axis_tdata  ;
  logic                  rx__m_axis_tvalid ;
  logic                  rx__m_axis_tready ;
  logic           [15:0] rx__idivider      ;
  logic                  rx__irx           ;



  sv_uart_rx
  #(
    . DATA_WIDTH    (DATA_WIDTH      ) ,
    . IN_PIPE       (IN_PIPE         ) 
  )
  rx__
  (
    .iclk          (rx__iclk               ) ,
    .irst          (rx__irst               ) ,
    .m_axis_tdata  (rx__m_axis_tdata       ) ,
    .m_axis_tvalid (rx__m_axis_tvalid      ) ,
    .m_axis_tready (rx__m_axis_tready      ) ,
    .idivider      (rx__idivider           ) ,
    .irx           (rx__irx                ) 
  );


  assign rx__iclk          = '0;
  assign rx__irst          = '0;
  assign rx__m_axis_tready = '0;
  assign rx__idivider      = '0;
  assign rx__irx           = '0;



*/ 

//
// Project       : UART core
// Author        : Borshch Vladislav
// Contacts      : borchsh.vn@gmail.com
// Workfile      : sv_uart_rx.sv
// Description   : AXIstream UART receiver
//

module sv_uart_rx
#(
  parameter int DATA_WIDTH = 8 ,
  parameter int IN_PIPE    = 5 
)
(
  input  logic                  iclk          ,
  input  logic                  irst          ,
  output logic [DATA_WIDTH-1:0] m_axis_tdata  ,
  output logic                  m_axis_tvalid ,
  input  logic                  m_axis_tready ,
  input  logic           [15:0] idivider      ,
  input  logic                  irx           
);

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  logic               [2:0] metastab = '0;
  logic       [IN_PIPE-1:0] frx      = '0;
  logic                     true_rx  = '0;
  logic                     dtrue_rx = '0;
  logic                     ena      = '0;
  logic                     clk_ena  = '0;
  logic                     fall_rx  = '0;
  logic                     eop      = '0;
  logic              [15:0] cnt      = '0;
  logic               [3:0] cnt_pack = '0;
  logic               [7:0] freg     = '0;

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  // Metastable & CDC pipe
  always_ff@(posedge iclk) begin
    metastab <= metastab << 1 | irx;
    frx <= frx << 1 | metastab[2];

    if (&frx)             true_rx <= 1'b1;
    else if (frx == 'd0)  true_rx <= 1'b0;

    dtrue_rx <= true_rx;
  end

  // Front detection
  always_ff@(posedge iclk) begin
    fall_rx <= dtrue_rx & ~true_rx;
  end

  // Engine
  always_ff@(posedge iclk) begin
    if (fall_rx)       ena <= 1'b1;
    else if (eop)      ena <= 1'b0;

    if (irst)          cnt <= '0;
    else if (clk_ena)  cnt <= '0;
      else if (~ena)   cnt <= '0;
        else if (ena)  cnt <= cnt + 1'b1;
    // First clock with shift by T/2 for good signal phase
    if (cnt_pack == 0)
      clk_ena <= (cnt == (idivider >> 2)-2) && ena;
    else
      clk_ena <= (cnt == idivider-2) && ena;

    if (irst)                  cnt_pack <= '0;
    else if (~ena)             cnt_pack <= '0;
      else if (ena & clk_ena)  cnt_pack <= cnt_pack + 1'b1;

    eop <= (cnt_pack == 4'd8) & ena & clk_ena; // START + 8 DATA bytes
  end

  // Data collect
  always_ff@(posedge iclk) begin
    if (clk_ena)  freg <= {true_rx, freg[7:1]};
  end

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  always_ff@(posedge iclk) begin
    m_axis_tvalid <= eop && m_axis_tready;
    if (m_axis_tready && eop)
      m_axis_tdata <= freg;
  end

endmodule
