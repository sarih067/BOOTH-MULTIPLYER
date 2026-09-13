module Booth_multi(
    input clk,rst,
    input [15:0] data_in,
    output [31:0] data_out,
    output done
);
    wire law,lqw,lmw,clraw,clrqw,clrmw,clrq_1w,Ashiftw,asw,cnt_clrw,deccw,selaw,selqw,lq_1w,cw;
    wire [1:0] qw;
    Control_Path CP(
        .reset(rst),
        .clk(clk),

        .count_out(cw),
        .q_out(qw),

        .sela(selaw),
        .la(law),
        .clra(clraw),

        .selq(selqw),
        .lq(lqw),
        .clrq(clrqw),

        .lq_1(lq_1w),
        .clrq_1(clrq_1w),
        
        .ashift(Ashiftw),

        .as(asw),
        
        .lm(lmw),
        .clrm(clrmw),
        .clrc(cnt_clrw),
        .decc(deccw),
        .done(done)

    );
    Data_Path DP (
        .data_in(data_in),

        .la(law),
        .lq(lqw),
        .lm(lmw),

        .clra(clraw),
        .clrq(clrqw),
        .clrm(clrmw),
        .clrq_1(clrq_1w),

        .Ashift(Ashiftw),
        .as(asw),

        .clk(clk),
        .cnt_clr(cnt_clrw),
        .decc(deccw),

        .sela(selaw),
        .selq(selqw),
        .lq_1(lq_1w),

        .q_out(qw),
        .count_out(cw),
        .product(data_out)
    );
endmodule