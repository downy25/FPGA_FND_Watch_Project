module counter_4digit(
  iCLK,
  iRESETn,
  oDATA_FND,
  oCOM_FND
);
  input iCLK,iRESETn;
  output [7:0] oDATA_FND;
  output [3:0] oCOM_FND;

  wire en_200;
  wire en_1;
  wire [15:0] data_cnt;


  freq_div_fnd UFD(
    .iCLK(iCLK),
    .iRESETn(iRESETn),
    .oEN_200(en_200),
    .oEN_1 (en_1)
  );

  bcd_cnt UBCD(
    .iCLK(iCLK),
    .iRESETn(iRESETn),
    .iEN_1(en_1),
    .oDATA_CNT(data_cnt)
  );

  drv_fnd4 UDRV(
    .iCLK(iCLK),
    .iRESETn(iRESETn),
    .iEN_200(en_200),
    .iBCD(data_cnt),
    .oCOM_FND(oCOM_FND),
    .oDATA_FND(oDATA_FND)
  );
endmodule