`timescale 1ns / 1ps
module Data_Path(
    input signed [15:0]  data_in,
    input la,lq,lm,clra,clrq,clrm,clrq_1,Ashift,as,clk,cnt_clr,decc,sela,selq,lq_1,
    output [1:0]q_out,
    output count_out,
    output signed [31:0]  product
);
    wire signed [15:0] x,z,q,m;
    wire q_1;
    wire [32:0] shift_out;
    wire [4:0] count;
    data_handle A (.load(la), .clr(clra), .clk(clk), .sel(sela), .data0(z), .data1(shift_out[32:17]), .data_out(x));
    PIPO M (.load(lm), .clr(clrm), .clk(clk), .data(data_in), .out(m));
    data_handle Q (.load(lq), .clr(clrq), .clk(clk), .sel(selq), .data0(data_in), .data1(shift_out[16:1]), .data_out(q));
    D_ff DFF (.clr(clrq_1), .clk(clk), .load(lq_1), .data(shift_out[0]), .out(q_1));
    shift S (.A(x), .Q(q), .Q_1(q_1), .arsht(Ashift), .out(shift_out));
    counter Counter (.clr(cnt_clr), .dec(decc), .clk(clk), .out(count));
    add_sub ASU (.a_s(as), .a(x), .b(m), .out(z));
    assign q_out={q[0],q_1};
    assign product = $signed ({x,q});
    assign count_out=~|count;
endmodule

module data_handle(
    input load,clr,clk,sel,
    input signed [15:0] data1,data0,
    output reg signed [15:0] data_out
);
    always @(posedge clk)
    begin
        if(clr)
            data_out<=16'b0;
        else if(load)
            data_out<=sel?data1:data0;

    end
endmodule

module PIPO (
    input signed [15:0] data,
    input clk,clr,load,
    output reg signed[15:0] out
);
    always @(posedge clk) 
    begin
        if(clr)
            out<=16'b0;
        else if (load)
            out<=data;
    end
endmodule

module add_sub(
    input a_s,
    input signed [15:0] a,b,
    output reg signed [15:0] out
);
    always @(*)
    begin
        if(a_s)
            out=a+b;
        else if(~a_s)
            out=a-b;
    end
endmodule

module D_ff(
    input clr,clk,data,load,
    output reg out
);
    always @(posedge clk) 
    begin
        if (clr)
            out<=1'b0;
        else if (load)
            out<=data;
    end
endmodule

module shift (
    input signed [15:0] A,Q,
    input Q_1,arsht,
    output reg signed [32:0] out
);
    always @(*)
    begin
        if(arsht)
        begin
            out= $signed ({A,Q,Q_1})>>>1;
        end
        else
            out= $signed({A,Q,Q_1});
    end
endmodule

module counter(
    input clr,dec,clk,
    output reg [4:0] out
);
    always @(posedge clk)
    begin
        if(clr)
            out<=5'b10000;
        else if(dec && out != 5'b00000)
            out<=out-5'b00001; 
    end
endmodule
