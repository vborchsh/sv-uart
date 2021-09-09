/*



  parameter int DATA_WIDTH = 8;
  parameter int STOP_BITS  = 1;



  logic                  tx__iclk          ;
  logic                  tx__irst          ;
  logic [DATA_WIDTH-1:0] tx__s_axis_tdata  ;
  logic                  tx__s_axis_tvalid ;
  logic                  tx__s_axis_tready ;
  logic           [15:0] tx__idivider      ;
  logic                  tx__otx           ;



  sv_uart_tx
  #(
    . DATA_WIDTH    (DATA_WIDTH      ) ,
    . STOP_BITS     (STOP_BITS       ) 
  )
  tx__
  (
    .iclk          (tx__iclk               ) ,
    .irst          (tx__irst               ) ,
    .s_axis_tdata  (tx__s_axis_tdata       ) ,
    .s_axis_tvalid (tx__s_axis_tvalid      ) ,
    .s_axis_tready (tx__s_axis_tready      ) ,
    .idivider      (tx__idivider           ) ,
    .otx           (tx__otx                ) 
  );


  assign tx__iclk          = '0;
  assign tx__irst          = '0;
  assign tx__s_axis_tdata  = '0;
  assign tx__s_axis_tvalid = '0;
  assign tx__idivider      = '0;



*/

//
// Project       : UART core
// Author        : Borshch Vladislav
// Contacts      : borchsh.vn@gmail.com
// Workfile      : sv_uart_tx.sv
// Description   : AXIstream UART transmitter
//

module sv_uart_tx
#(
  parameter int DATA_WIDTH = 8 ,
  parameter int STOP_BITS  = 1 
)
(
  input  logic                  iclk          ,
  input  logic                  irst          ,
  input  logic [DATA_WIDTH-1:0] s_axis_tdata  ,
  input  logic                  s_axis_tvalid ,
  output logic                  s_axis_tready ,
  input  logic           [15:0] idivider      ,
  output logic                  otx           
);

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  localparam int INT_WIDTH = DATA_WIDTH + STOP_BITS + 1;

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  logic                       clk_ena  = '0;
  logic                [15:0] baud_gen = '0;
  logic                 [4:0] cnt      = '0;
  logic       [INT_WIDTH-1:0] freg     = '0;
  logic       [STOP_BITS-1:0] stopbits = '1;

  enum logic [2:0] {
    ST_WAIT = 2'd0,
    ST_SOP  = 2'd1,
    ST_DAT  = 2'd2,
    ST_EOP  = 2'd3
  } ST;

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  // Prescaler
  always_ff@(posedge iclk) begin
    if (irst)                  baud_gen <= '0;
    else if (clk_ena)          baud_gen <= '0;
      else if (ST != ST_WAIT)  baud_gen <= baud_gen + 1'b1;
    clk_ena <= (baud_gen == idivider-1);
  end

  always_ff@(posedge iclk) begin
    if (irst)  ST <= ST_WAIT;
    else case (ST)
      ST_WAIT : if (s_axis_tvalid)                  ST <= ST_SOP;
      ST_SOP  : if (clk_ena)                        ST <= ST_DAT;
      ST_DAT  : if (cnt == INT_WIDTH-2 && clk_ena)  ST <= ST_EOP;
      ST_EOP  : if (clk_ena)                        ST <= ST_WAIT;
      default : ST <= ST_WAIT;
    endcase
  end

  always_ff@(posedge iclk) begin
    // Bit counter
    if (ST == ST_SOP)                    cnt <= '0;
    else if (clk_ena)                    cnt <= cnt + 1'b1;
    // One word forming
    if (s_axis_tvalid && s_axis_tready)  freg <= {stopbits, s_axis_tdata, 1'b0}; // STOP, DATA, START
    else if (clk_ena)                    freg <= freg >> 1;
  end

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------

  always_ff@(posedge iclk) begin
    if (irst)                s_axis_tready <= '0;
    else if (s_axis_tvalid)  s_axis_tready <= (ST == ST_WAIT);

    if ((cnt > INT_WIDTH-2) || (ST == ST_WAIT))  otx <= 1'b1;
    else if (clk_ena)                            otx <= freg[$low(freg)];
  end

endmodule
