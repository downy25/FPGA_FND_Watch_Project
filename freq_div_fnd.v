module freq_div_fnd(
  iCLK,
  iRESETn,
  oEN_200,
  oEN_1
);

  localparam VAL_CNT200 = 21'd625000;
  localparam VAL_CNT1 = 28'd125000000;

  input iCLK,iRESETn;
  output oEN_200;
  output oEN_1;

  reg [20:0] cnt_en_200;
  reg [27:0] cnt_en_1;
  reg        en_200;
  reg        en_1;

  assign oEN_200 = en_200;
  assign oEN_1   = en_1;

  always @(posedge iCLK or posedge iRESETn) begin
    if(iRESETn) begin
      cnt_en_200 <= 0;
      en_200     <= 0;
    end
    else if(cnt_en_200 == VAL_CNT200 - 1)begin
      cnt_en_200 <= 0;
      en_200 <= 1;
    end
    else begin
      cnt_en_200 <= cnt_en_200 + 1'b1;
      en_200     <= 0;
    end
  end

  always @(posedge iCLK or posedge iRESETn) begin
    if(iRESETn) begin
      cnt_en_1 <= 0;
      en_1 <= 0;
    end else if(cnt_en_1 == VAL_CNT1 - 1)begin
      cnt_en_1 <= 0;
      en_1     <= 1;
    end else begin
      cnt_en_1  <= cnt_en_1 + 1'b1;
      en_1 <= 0;
    end
  end

endmodule