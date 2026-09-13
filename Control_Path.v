`timescale 1ns / 1ps

module Control_Path(
    input clk,count_out,reset,
    input [1:0] q_out,
    output reg sela,la,clra,selq,lq,clrq,clrq_1,ashift,as,lm,clrm,clrc,decc,done,lq_1
);
    reg[2:0] state;
    localparam s0 = 3'b000 ;
    localparam s1 = 3'b001 ;
    localparam s2 = 3'b010 ;
    localparam s3 = 3'b011 ;
    localparam s4 = 3'b100 ;
    localparam s5 = 3'b101 ;
    localparam s6 = 3'b110 ;

   always @(posedge clk) begin

        if(reset)
            state<=s0;
        else
            begin
                case (state)
                    s0: state<=s1;
                    s1: state<=s2;
                    s2: 
                        begin
                            if(q_out==2'b01)
                                state<=s3;
                            else if(q_out==2'b10)
                                state<=s4;
                            else if(q_out==2'b00||q_out==2'b11)
                                state<=s5;
                        end 
                    s3: state<=s5;
                    s4: state<=s5;
                    s5: 
                        begin
                            if(count_out==1'b1) 
                                state<=s6;
                            else if(q_out==2'b10 && count_out==1'b0)
                                state<=s4;
                            else if(q_out==2'b01 && count_out==1'b0)
                                state<=s3;
                            else
                                state<=s5;
                        end
                    s6: state<=s6;
                    default: state<=s0;
                endcase
            end
    end

    always @(*) begin
            sela=0;
            la=0;
            clra=0;

            selq=0;
            lq=0;
            clrq=0;

            lq_1=0;
            clrq_1=0;

            ashift=0;
            as=0;

            lm=0;
            clrm=0;

            clrc=0;
            decc=0;

            done=0;
            case (state)
                s0:
                    begin
                        clrm=1;
                    end 
                s1:
                    begin
                        lm=1;
                        clra=1;
                        clrq=1;
                        clrq_1=1;
                        clrc=1;
                    end
                s2:
                    begin
                        selq=0;
                        lq=1;
                    end
                s3:
                    begin
                        as=1;
                        sela=0;
                        la=1;
                    end
                s4:
                    begin
                        la=1;
                    end
                s5:
                    begin
                        ashift=1;
                        decc=1;
                        sela=1;
                        la=1;
                        selq=1;
                        lq=1;
                        lq_1=1;
                    end
                s6:
                    begin
                        done=1;     
                    end
                default: 
                    begin

                    end
            endcase 
            
    end
endmodule