module drv_fnd4(
  iCLK,
  iRESETn,
  iEN_200,
  iBCD,
  oCOM_FND,
  oDATA_FND
);
  localparam BCD_FND0 = 4'd0;
  localparam BCD_FND1 = 4'd1;
  localparam BCD_FND2 = 4'd2;
  localparam BCD_FND3 = 4'd3;
  localparam BCD_FND4 = 4'd4;
  localparam BCD_FND5 = 4'd5;
  localparam BCD_FND6 = 4'd6;
  localparam BCD_FND7 = 4'd7;
  localparam BCD_FND8 = 4'd8;
  localparam BCD_FND9 = 4'd9;

  input iCLK,iRESETn;
  input iEN_200;
  input [15:0] iBCD;
  output [3:0] oCOM_FND;
  output [7:0] oDATA_FND;

  reg [1:0] sel_cnt;
  reg [3:0] bcd;
  reg [3:0] com_fnd;
  reg [7:0] data_fnd;
  
  
  

  //7세그먼트 자릿수 선택을 위한 카운터
  always @(posedge iCLK or posedge iRESETn) begin
    if(iRESETn) sel_cnt <= 2'b00;
    else if(iEN_200 == 1) sel_cnt <= sel_cnt + 2'b01;
    else sel_cnt <= sel_cnt;
  end

  //자릿수 선택 카운터의 계수값에 다른 7세그먼트 공통 단자 선택
  always @(posedge iCLK or posedge iRESETn) begin
    if(iRESETn) com_fnd <= 4'b0000;
    else begin
      case(sel_cnt)
        2'd0: com_fnd <= 4'b1110; //일의 자리 FND 선택
        2'd1: com_fnd <= 4'b1101; //십의 자리 FND 선택
        2'd2: com_fnd <= 4'b1011; //백의 자리 FND 선택
        2'd3: com_fnd <= 4'b0111; //천의 자리 FND 선택
        default : com_fnd <= 4'b1111; //otherwise
      endcase
    end
  end

  //선택한 자릿수에 표시할 BCD 카운터의 계수값
  always @(posedge iCLK or posedge iRESETn) begin
    if(iRESETn)
      bcd <= 4'b0000;
    else begin
      case(sel_cnt)
        2'd0: bcd <= iBCD[3:0];
        2'd1: bcd <= iBCD[7:4];
        2'd2: bcd <= iBCD[11:8];
        2'd3: bcd <= iBCD[15:12];
        default : bcd <= 4'b0;
      endcase
    end
  end

  always @(posedge iCLK or posedge iRESETn) begin
    if(iRESETn) data_fnd <= 8'b1111_1111;
    else begin
      case(bcd)
        BCD_FND0 : data_fnd = 8'b1111_1100; //'0'
        BCD_FND1 : data_fnd = 8'b0110_0000; //'1'
        BCD_FND2 : data_fnd = 8'b1101_1010; //'2'
        BCD_FND3 : data_fnd = 8'b1111_0010; //'3'
        BCD_FND4 : data_fnd = 8'b0110_0110; //'4'
        BCD_FND5 : data_fnd = 8'b1011_0110; //'5'
        BCD_FND6 : data_fnd = 8'b1011_1110; //'6'
        BCD_FND7 : data_fnd = 8'b1110_0100; //'7'
        BCD_FND8 : data_fnd = 8'b1111_1110; //'8'
        BCD_FND9 : data_fnd = 8'b1111_0110; //'9'
        default :  data_fnd = 8'b1111_1111;
      endcase
    end
  end

  assign oCOM_FND = com_fnd;
  assign oDATA_FND = data_fnd;

endmodule